# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/radvd/radvd-1.6.ebuild,v 1.3 2010/07/14 11:00:55 hwoarang Exp $

EAPI=2
inherit eutils

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"
SRC_URI="http://v6web.litech.org/radvd/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc sparc x86 ~x86-fbsd"
IUSE="kernel_FreeBSD"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=""

pkg_setup() {
	enewgroup radvd
	enewuser radvd -1 -1 /dev/null radvd

	# force ownership of radvd user and group (bug #19647)
	[[ -d ${ROOT}/var/run/radvd ]] && chown radvd:radvd "${ROOT}"/var/run/radvd
}

src_configure() {
	econf \
		--with-pidfile=/var/run/radvd/radvd.pid \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGES README TODO radvd.conf.example || die
	dohtml INTRO.html || die

	newinitd "${FILESDIR}/${PN}".init "${PN}" || die
	newconfd "${FILESDIR}/${PN}".conf "${PN}" || die

	# location of radvd.pid needs to be writeable by the radvd user
	keepdir /var/run/radvd
	chown -R radvd:radvd "${D}"/var/run/radvd || die
	fperms 755 /var/run/radvd

	if use kernel_FreeBSD ; then
		sed -i -e \
			's/^SYSCTL_FORWARD=.*$/SYSCTL_FORWARD=net.inet6.ip6.forwarding/g' \
			"${D}"/etc/init.d/"${PN}" || die
	fi
}

pkg_postinst() {
	elog
	elog "To use ${PN} you must create the configuration file"
	elog "${ROOT}etc/radvd.conf"
	elog
	elog "An example configuration file has been installed under"
	elog "${ROOT}usr/share/doc/${PF}"
	elog
	elog "grsecurity users should allow a specific group to read /proc"
	elog "and add the radvd user to that group, otherwise radvd may"
	elog "segfault on startup."
}
