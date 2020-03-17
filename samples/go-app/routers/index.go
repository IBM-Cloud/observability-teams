package routers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	c.HTML(http.StatusOK, "index.html", nil)
}

func NotFoundError(c *gin.Context) {
	c.HTML(http.StatusOK, "404.html", nil)
}

func InternalServerError(c *gin.Context) {
	c.HTML(http.StatusOK, "500.html", nil)
}
