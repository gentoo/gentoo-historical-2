# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/putty/putty-20030603.ebuild,v 1.1 2003/06/03 15:57:53 taviso Exp $

cvs_update="20030603"
DESCRIPTION="UNIX port of the famous Windows SSH client"

inherit ccc

HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/putty/"
SRC_URI="http://cvs.gentoo.org/~taviso/putty-cvs-${cvs_update}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~x86 ~alpha"

IUSE=""
DEPEND="dev-lang/perl
	>=sys-apps/sed-4
	virtual/x11
	~dev-libs/glib-1.2.10
	~x11-libs/gtk+-1.2.10"

RDEPEND="virtual/x11
	~dev-libs/glib-1.2.10
	~x11-libs/gtk+-1.2.10"

S=${WORKDIR}/${PN}

src_compile() {
	
	# generate the makefiles
	${S}/mkfiles.pl || die "failed to create makefiles."

	# change the CFLLAGS to those requested by user.
	sed -i "s/-O2/${CFLAGS}/g" ${S}/unix/Makefile.gtk

	# build putty.
	cd ${S}/unix; emake -f Makefile.gtk || die "build failed."
}

src_install() {
	
	cd ${S}/unix
	
	# man pages...
	doman plink.1 pterm.1 putty.1 puttytel.1
	
	# binaries...
	dobin plink pterm putty puttytel
	
	cd ${S}

	# docs...
	dodoc README README.txt LICENSE doc/*
}

pkg_postinst() {
	einfo "Please note that pterm will not work without UNIX98 PTYS support"
	einfo "If you want to use pterm, you may have to enable it."
}
