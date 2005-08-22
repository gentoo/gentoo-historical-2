# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/lighttpd/lighttpd-1.4.1.ebuild,v 1.1 2005/08/22 16:01:18 ka0ttic Exp $

inherit eutils check-kernel toolchain-funcs

# bug #97661 - tests try to load modules from /usr/lib/lighttpd.
# Needless to say, this will fail because either
#   a) they don't exist since this is a first install, or
#   b) they do exist, but they are from the previously installed version
RESTRICT="test"

DESCRIPTION="Lightweight high-performance web server"
HOMEPAGE="http://www.lighttpd.net/"
SRC_URI="http://www.lighttpd.net/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="doc fam gdbm ipv6 ldap lua mysql php ssl webdav xattr"

RDEPEND="app-arch/bzip2
		>=sys-libs/zlib-1.1
		>=dev-libs/libpcre-3.1
		fam?      ( app-admin/gamin )
		gdbm?     ( sys-libs/gdbm )
		ldap?     ( >=net-nds/openldap-2.1.26 )
		lua?      ( dev-lang/lua )
		mysql?    ( >=dev-db/mysql-4.0.0 )
		php?      (
			>=dev-php/php-cgi-4.3.0
			!net-www/spawn-fcgi
		)
		ssl?    ( >=dev-libs/openssl-0.9.7 )
		webdav? (
			dev-libs/libxml2
			>=dev-db/sqlite-3
		)
		xattr?  ( sys-apps/attr )"

DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"

# update certain parts of lighttpd.conf based on
# conditionals (such as kernel, USE flags, etc).
update_config() {
	local config="/etc/lighttpd/lighttpd.conf"

	# enable mod_fastcgi settings
	use php && \
		dosed 's|#.*\(include.*fastcgi.*$\)|\1|' ${config}

	# enable stat() caching
	use fam && \
		dosed 's|#\(.*stat-cache.*$\)|\1|' ${config}

	# Note to arch maintainers, the "linux-sysepoll" event-handler doesn't
	# seem to work on mips even with a 2.6 kernel, so please make sure you
	# test the respective server.event-handler option before adding your
	# arch.
	case "$(tc-arch)" in
		x86)
			# use appropriate server.event-handler directive based on kernel
			if use kernel_linux ; then

				is_2_6_kernel && \
					dosed 's|#\(.*event-handler.*sysepoll.*$\)|\1|' ${config}

				is_2_4_kernel &&
					dosed 's|#\(.*event-handler.*rtsig.*$\)|\1|' ${config}

			elif use kernel_FreeBSD ; then
				dosed 's|#\(.*event-handler.*kqueue.*$\)|\1|' ${config}
			fi
			;;
		*)
			;;
	esac
}

src_unpack() {
	unpack ${A}
	cd ${S}

#    EPATCH_SUFFIX="diff" epatch ${FILESDIR}/${PV}

	# dev-python/docutils installs rst2html.py not rst2html
	sed -i -e 's|\(rst2html\)|\1.py|g' doc/Makefile.in || \
		die "sed doc/Makefile.in failed"
}

src_compile() {
#    einfo "Regenerating autoconf/automake files"
#    libtoolize --copy --force || die "libtoolize failed"
#    aclocal || die "aclocal failed"
#    autoheader || die "autoheader failed"
#    automake --add-missing --copy || die "automake failed"
#    autoconf || die "autoconf failed"

	local myconf="--libdir=/usr/$(get_libdir)/${PN}"

	# upstream recommends disabling LFS support with a 2.4.x kernel
	if is_2_4_kernel ; then
		myconf="${myconf} --disable-lfs"
	else
		myconf="${myconf} --enable-lfs"
	fi

	econf ${myconf} \
		$(use_enable ipv6) \
		$(use_with fam gamin) \
		$(use_with gdbm) \
		$(use_with lua) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with ssl openssl) \
		$(use_with webdav webdav-props) \
		$(use_with xattr attr) \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc ; then
		einfo "Building HTML documentation"
		cd doc
		emake html || die "failed to build HTML documentation"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# init script stuff
	newinitd ${FILESDIR}/lighttpd.initd lighttpd || die

	if use php ; then
		newinitd ${FILESDIR}/spawn-fcgi.initd spawn-fcgi || die
		newconfd ${FILESDIR}/spawn-fcgi.confd spawn-fcgi || die
	fi

	# configs
	insinto /etc/lighttpd
	doins ${FILESDIR}/conf/*.conf

	# update lighttpd.conf directives based on conditionals
	update_config

	# docs
	dodoc AUTHORS README COPYING INSTALL NEWS ChangeLog doc/*.sh
	newdoc doc/lighttpd.conf lighttpd.conf.distrib

	use doc && dohtml -r doc/*

	docinto txt
	dodoc doc/*.txt

	# logrotate
	insinto /etc/logrotate.d
	newins ${FILESDIR}/lighttpd.logrotate lighttpd || die

	keepdir /var/log/lighttpd /var/www/localhost/htdocs
}

pkg_preinst() {
	enewgroup lighttpd
	enewuser lighttpd -1 -1 /var/www/localhost/htdocs lighttpd
	fowners lighttpd:lighttpd /var/log/lighttpd
}

pkg_postinst () {
	echo
	if [[ -f ${ROOT}etc/conf.d/spawn-fcgi.conf ]] ; then
		einfo "spawn-fcgi is now included with lighttpd"
		einfo "spawn-fcgi's init script configuration is now located"
		einfo "at /etc/conf.d/spawn-fcgi."
		echo
	fi

	if [[ -f ${ROOT}etc/lighttpd.conf ]] ; then
		ewarn "As of lighttpd-1.4.0-r1, Gentoo has a customized configuration,"
		ewarn "which is now located in /etc/lighttpd.  Please migrate your"
		ewarn "existing configuration."
		ebeep 3
	fi
	echo
}
