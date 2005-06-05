# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/nmh/nmh-1.1.ebuild,v 1.5 2005/06/05 11:51:50 hansmi Exp $

inherit eutils
DESCRIPTION="New MH mail reader"
SRC_URI="http://savannah.nongnu.org/download/nmh/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/nmh/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="ppc sparc x86"
IUSE=""

DEPEND="virtual/libc
	=sys-libs/db-1.85*
	>=sys-libs/ncurses-5.2"

S=${WORKDIR}/${PN}

src_compile() {

	[ -z "${EDITOR}" ] && export EDITOR="prompter"
	[ -z "${PAGER}" ] && export PAGER="/usr/bin/more"

	# Patches from bug #22173.
	epatch ${FILESDIR}/${P}-inc-login.patch
	epatch ${FILESDIR}/${P}-install.patch
	# vi test access violation patch
	epatch ${FILESDIR}/${P}-configure-vitest.patch || die "patch failed."
	# bug #57886
	epatch ${FILESDIR}/${P}-m_getfld.patch || die "patch failed."

	# Redifining libdir to be bindir so the support binaries get installed
	# correctly.  Since no libraries are installed with nmh, this does not
	# pose a problem at this time.
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--with-editor=${EDITOR} \
		--with-pager=${PAGER} \
		--enable-nmh-pop \
		--sysconfdir=/etc/nmh \
		--libdir=/usr/bin || die
	make || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		libdir=${D}/usr/bin \
		etcdir=${D}/etc/nmh install || die
	dodoc COMPLETION-TCSH COMPLETION-ZSH TODO FAQ DIFFERENCES \
		MAIL.FILTERING Changelog* COPYRIGHT
}
