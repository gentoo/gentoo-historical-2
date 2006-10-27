# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/xdebug/xdebug-2.0.0_rc1.ebuild,v 1.3 2006/10/27 19:02:30 sebastian Exp $

PHP_EXT_ZENDEXT="yes"
PHP_EXT_NAME="xdebug"

inherit php-ext-source-r1

DESCRIPTION="A PHP Debugging and Profiling extension."
HOMEPAGE="http://www.xdebug.org/"
SLOT="0"
MY_P="${P/_/}"
SRC_URI="http://pecl.php.net/get/${MY_P}.tgz"
S="${WORKDIR}/xdebug-2.0.0RC1"
LICENSE="Xdebug"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="${RDEPEND}
	!dev-php5/ZendOptimizer
	dev-php/xdebug-client"

need_php_by_category

src_install() {
	php-ext-source-r1_src_install
	dodoc-php NEWS README Changelog CREDITS LICENSE

	php-ext-base-r1_addtoinifiles "xdebug.auto_trace" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.trace_output_dir" '"/tmp"'
	php-ext-base-r1_addtoinifiles "xdebug.trace_output_name" '"crc32"'
	php-ext-base-r1_addtoinifiles "xdebug.trace_format" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.trace_options" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.collect_includes" '"1"'
	php-ext-base-r1_addtoinifiles "xdebug.collect_params" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.collect_return" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.collect_vars" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.default_enable" '"1"'
	php-ext-base-r1_addtoinifiles "xdebug.extended_info" '"1"'
	php-ext-base-r1_addtoinifiles "xdebug.manual_url" '"http://www.php.net"'
	php-ext-base-r1_addtoinifiles "xdebug.max_nesting_level" '"100"'
	php-ext-base-r1_addtoinifiles "xdebug.show_exception_trace" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.show_local_vars" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.show_mem_delta" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.COOKIE" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.ENV" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.FILES" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.GET" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.POST" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.REQUEST" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.SERVER" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump.SESSION" '"NULL"'
	php-ext-base-r1_addtoinifiles "xdebug.dump_globals" '"1"'
	php-ext-base-r1_addtoinifiles "xdebug.dump_once" '"1"'
	php-ext-base-r1_addtoinifiles "xdebug.dump_undefined" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_enable" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_output_dir" '"/tmp"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_output_name" '"crc32"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_enable_trigger" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_append" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.profiler_aggregate" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_enable" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_handler" '"dbgp"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_host" '"localhost"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_mode" '"req"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_port" '"9000"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_autostart" '"0"'
	php-ext-base-r1_addtoinifiles "xdebug.remote_log" '""'
	php-ext-base-r1_addtoinifiles "xdebug.allowed_clients" '""'
	php-ext-base-r1_addtoinifiles "xdebug.idekey" '""'
	php-ext-base-r1_addtoinifiles "xdebug.var_display_max_data" '"512"'
	php-ext-base-r1_addtoinifiles "xdebug.var_display_max_depth" '"2"'
}
