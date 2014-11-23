
require.config(
	baseUrl: './scripts'				# 指定所有模块js的查找根路径
	paths:
		jQuery: 'lib/jquery-1.9.0'
	# 为那些没有使用define()来声明依赖关系、设置模块的"浏览器全局变量注入"型脚本做依赖和导出配置。
	shim:
		jQuery:
			exports: 'jQuery'
)

require ['jQuery', 'dist/App2048'], ($, App) ->
	$( ->
		new App('level0')
		return
	)
	return