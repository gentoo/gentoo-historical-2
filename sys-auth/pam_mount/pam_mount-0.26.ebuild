# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_mount/pam_mount-0.26.ebuild,v 1.1 2007/09/26 03:14:30 hanno Exp $

inherit eutils multilib pam

DESCRIPTION="A PAM module that can mount volumes for a user session"
HOMEPAGE="http://pam-mount.sourceforge.net"
SRC_URI="mirror://sourceforge/pam-mount/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="crypt"
DEPEND=">=sys-libs/pam-0.72
	dev-libs/openssl
	>=dev-libs/glib-2.0.0
	sys-libs/libhx
	dev-libs/libxml2"
RDEPEND="$DEPEND
	crypt? ( || ( >=sys-fs/cryptsetup-1.0.5 sys-fs/cryptsetup-luks ) )
	sys-process/lsof"

src_compile() {
	econf --with-slibdir="/$(get_libdir)" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dopamsecurity . config/pam_mount.conf.xml || die "dopamsecurity failed"

	dodoc doc/*.txt || die
}
