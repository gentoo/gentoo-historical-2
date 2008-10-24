# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/preload/preload-0.6.3-r4.ebuild,v 1.1 2008/10/24 01:38:43 darkside Exp $

inherit eutils

DESCRIPTION="Adaptive readahead daemon."
HOMEPAGE="http://sourceforge.net/projects/preload"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vanilla"

RDEPEND="dev-libs/glib"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Patch to add /opt & /lib32 to allowed files to preload. Submitted
	# upstream, bug #242580
	epatch "${FILESDIR}/${P}-conf.patch"
	epatch "${FILESDIR}/${P}-nice-segfault.patch"
	use vanilla || epatch "${FILESDIR}/${P}-forking-children.patch"
	use vanilla || epatch "${FILESDIR}/${P}-overlapping-io-bursts.patch"
}

src_compile() {
	econf --localstatedir=/var
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	rm -rf "${D}/etc/rc.d/" || die "rm rc.d failed"
	rm -rf "${D}/etc/sysconfig/" || die "rm sysconfig failed"
	rm -f "${D}/var/lib/preload/preload.state" || die "cleanup1 failed"
	rm -f "${D}/var/log/preload.log" || die "cleanup2 failed"
	keepdir /var/lib/preload
	keepdir /var/log
	newinitd "${FILESDIR}/init.d-preload" preload || die "initd failed"
	newconfd "${FILESDIR}/conf.d-preload" preload || die "confd failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

pkg_postinst() {
	elog "To start preload at boot, remember to add it to a runlevel:"
	elog "# rc-update add preload default"
}
