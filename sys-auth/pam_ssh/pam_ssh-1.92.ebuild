# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ssh/pam_ssh-1.92.ebuild,v 1.3 2008/07/22 22:46:22 flameeyes Exp $

inherit pam eutils

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.bz2"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

# Doesn't work on OpenPAM.
DEPEND="sys-libs/pam
	sys-devel/libtool"

RDEPEND="sys-libs/pam
	virtual/ssh"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.91-debian.patch" #105546
	epatch "${FILESDIR}/${PN}-1.91-syslog.patch" # glibc-2.4
}

src_compile() {
	econf \
		"--with-pam-dir=$(getpam_mod_dir)" \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elog "You can enable pam_ssh for system authentication by enabling"
	elog "the ssh USE flag on sys-auth/pambase."
}
