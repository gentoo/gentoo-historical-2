# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/johntheripper/johntheripper-1.6-r1.ebuild,v 1.1 2003/02/13 06:10:21 zhen Exp $

inherit eutils

IUSE="mmx"

MY_P=${P/theripper/}
S=${WORKDIR}/${MY_P}
DEBPATCH=${MY_P/-/_}-17.diff
DESCRIPTION="John the Ripper is a fast password cracker."
HOMEPAGE="http://www.openwall.com/${PN/theripper/}/"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz
	 http://ftp.debian.org/debian/pool/main/j/${PN/theripper/}/${DEBPATCH}.gz
	 http://cvs.gentoo.org/~zhen/${P}-r1-gentoo.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-x86 -sparc -ppc -alpha -mips -hppa"

DEPEND=">=sys-devel/binutils-2.8.1.0.15"

src_unpack() {
	unpack ${A}
	epatch ${WORKDIR}/${DEBPATCH}
	epatch ${WORKDIR}/${P}-r1-gentoo
}

src_compile() {
	cd src
	mv Makefile Makefile.orig
	sed -e "s:-m486::" -e "s:-Wall -O2:${CFLAGS}:" \
		Makefile.orig > Makefile
	if [ `use mmx` ] ; then
		emake linux-x86-mmx-elf || die
	else
		emake generic || die
	fi
}

src_install() {
	insinto /etc
	doins run/john.ini debian/john-mail.msg debian/john-mail.conf
	insinto /usr/share/${PN/theripper/}
	doins run/{all.chr,alpha.chr,digits.chr,lanman.chr,password.lst} \
		debian/john-dailyscript
	doman debian/*.1
	dosbin run/john debian/mailer debian/john-cronjob

	dosym john /usr/sbin/unafs 
	dosym john /usr/sbin/unique 
	dosym john /usr/sbin/unshadow

	dodoc debian/{CONFIG.mailer,copyright} doc/* 
}
