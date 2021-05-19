const client = require('prom-client');
const express = require('express');
const server = express();
const register = new client.Registry();
const { join } = require('path');
const morgan = require("morgan");

// Probe every 5th second.
const intervalCollector = client.collectDefaultMetrics({prefix: 'node_', timeout: 5000, register});

const counter = new client.Counter({
    name: "node_my_counter",
    help: "This is my counter"
});

const gauge = new client.Gauge({
    name: "node_my_gauge",
    help: "This is my gauge"
});

const histogram = new client.Histogram({
    name: "node_my_histogram",
    help: "This is my histogram",
    buckets: [0.1, 5, 15, 50, 100, 500]
});

const summary = new client.Summary({
    name: "node_my_summary",
    help: "This is my summary",
    percentiles: [0.01, 0.05, 0.5, 0.9, 0.95, 0.99, 0.999]
});

const requestHistogram = new client.Histogram({
    name: "request_histogram",
    help: "Histogram for requests",
    labelNames: ['status_code'],
    buckets: [0.1, 5, 15, 50, 100, 500]
});

register.registerMetric(counter);
register.registerMetric(gauge);
register.registerMetric(histogram);
register.registerMetric(summary);
register.registerMetric(requestHistogram);

const rand = (low, high) => Math.random() * (high - low) + low;

setInterval(() => {
    counter.inc(rand(0, 1));

    gauge.set(rand(0, 15));

    histogram.observe(rand(0, 10));

    summary.observe(rand(0, 10));


}, 1000);

const custom =
  ':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length] ":referrer" ":user-agent" :response-time ms :pid :local-address';

const system = require("./utils/logger").systemLog("/var/log");
const access = require("./utils/logger").accessLog("/var/log");

morgan.token("pid", req => process.pid);
morgan.token("local-address", req => req.socket.address().port);
server.use(morgan(custom, { skip: (req, res) => res.statusCode < 400 }));
server.use(morgan(custom, { stream: access }));

server.get("/health", function(req, res, next) {
  system.info(`{ status: "UP" }`);
  res.json({ status: "UP" });
});

server.get('/metrics', (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(register.metrics());
});

// Middleware
function newObservableRequest(histogram, func) {
    return (req, res) => {
        let start = +new Date();
        func(req, res);
        let end = +new Date();
        let elapsed = end - start;
        let code = req.method === "GET" ? "200" : "400";
        histogram.labels(code).observe(elapsed);
    }
}

server.get('/', (req,res) => {
  res.sendFile(join(__dirname,'./public/index.html'));
});

// server.get('/', newObservableRequest(requestHistogram, (req, res) => {
//     console.log("GET");
//     res.end();
// }));

// server.post('/', newObservableRequest(requestHistogram, (req, res) => {
//     console.log("POST");
//     res.end();
// }));

system.info(`Server listening to 8081, metrics exposed on /metrics endpoint`);
console.log('Server listening to 8081, metrics exposed on /metrics endpoint');
server.listen(8081);
