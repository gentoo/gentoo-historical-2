# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wdm/wdm-1.28-r1.ebuild,v 1.3 2007/07/02 16:56:35 armin76 Exp $

inherit eutils pam

IUSE="truetype pam selinux"

DESCRIPTION="WINGs Display Manager"
HOMEPAGE="http://voins.program.ru/wdm/"
SRC_URI="http://voins.program.ru/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~sparc x86"
LICENSE="GPL-2"

RDEPEND=">=x11-wm/windowmaker-0.70.0
	truetype? ( virtual/xft )
	x11-libs/libXt
	x11-libs/libXpm
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_compile() {
	econf \
		--exec-prefix=/usr \
		--with-wdmdir=/etc/X11/wdm \
		$(use_enable pam)\
		$(use_enable selinux) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	rm -f ${D}/etc/pam.d/wdm
	newpamd "${FILESDIR}/wdm-include.1" wdm
}
