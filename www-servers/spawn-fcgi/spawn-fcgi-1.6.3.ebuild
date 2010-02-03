# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/spawn-fcgi/spawn-fcgi-1.6.3.ebuild,v 1.3 2010/02/03 10:04:21 fauli Exp $

EAPI="2"

DESCRIPTION="A FCGI spawner for lighttpd and cherokee and other webservers"
HOMEPAGE="http://redmine.lighttpd.net/projects/spawn-fcgi"
SRC_URI="http://www.lighttpd.net/download/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ppc64 ~sh ~sparc x86"
IUSE="ipv6"

DEPEND=""
RDEPEND="!<=www-servers/lighttpd-1.4.20
	!<=www-servers/cherokee-0.98.1"

src_configure() {
	econf \
		$(use_enable ipv6 )
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'
	dodoc README NEWS

	newconfd "${FILESDIR}"/spawn-fcgi.confd spawn-fcgi
	newinitd "${FILESDIR}"/spawn-fcgi.initd spawn-fcgi
	#pidfile dir
	keepdir /var/run/spawn-fcgi
	fperms 0700 /var/run/spawn-fcgi

	docinto examples
	dodoc doc/run-generic doc/run-php doc/run-rails
}
