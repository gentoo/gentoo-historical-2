# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/radvd/radvd-1.0.ebuild,v 1.1 2006/11/01 17:29:29 uberlord Exp $

inherit eutils

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"
SRC_URI="http://v6web.litech.org/radvd/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=">=sys-process/procps-3.2"

pkg_setup() {
	enewgroup radvd
	enewuser radvd -1 -1 /dev/null radvd

	# force ownership of radvd user and group (bug #19647)
	[[ -d ${ROOT}/var/run/radvd ]] && chown radvd:radvd "${ROOT}"/var/run/radvd
}

src_compile() {
	econf \
		--with-pidfile=/var/run/radvd/radvd.pid \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGES README TODO radvd.conf.example
	dohtml INTRO.html

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	newconfd "${FILESDIR}/${PN}".conf "${PN}"

	# location of radvd.pid needs to be writeable by the radvd user
	keepdir /var/run/radvd
	chown -R radvd:radvd "${D}"/var/run/radvd
	fperms 755 /var/run/radvd
}

pkg_postinst() {
	einfo
	einfo "To use ${PN} you must create the configuration file"
	einfo "/etc/radvd.conf"
	einfo
	einfo "An example configuration file has been installed as"
	einfo "/usr/share/doc/${PF}/radvd.conf.example.gz"
	einfo
	einfo "grsec users should allow a specific group to read /proc"
	einfo "and add the radvd user to that group, otherwise radvd may"
	einfo "segfault on startup"
}
