# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/hylafax/hylafax-4.1.3.ebuild,v 1.3 2002/08/27 18:11:20 raker Exp $

S=${WORKDIR}/${P}
MYSED=sed-3.02
PATCHES=${WORKDIR}/patches

DESCRIPTION="Fax package for class 1 and 2 fax modems."
SRC_URI="ftp://ftp.hylafax.org/source/${P}.tar.gz"
HOMEPAGE="http://www.hylafax.org"

KEYWORDS="x86 -ppc -sparc -sparc64"
LICENSE="freedist"
SLOT="0"

DEPEND="net-dialup/mgetty
	sys-libs/zlib
	app-text/ghostscript
	media-libs/tiff
	jpeg? ( media-libs/jpeg )"

src_compile() {
	
	./configure	\
		--with-DIR_BIN=/usr/bin \
		--with-DIR_SBIN=/usr/sbin \
		--with-DIR_LIB=/usr/lib \
		--with-DIR_LIBEXEC=/usr/sbin \
		--with-DIR_LIBDATA=/usr/lib/fax \
		--with-DIR_LOCKS=/var/lock \
		--with-DIR_MAN=/usr/share/man \
		--with-DIR_SPOOL=/var/spool/fax \
		--with-AFM=no \
		--with-AWK=/usr/bin/gawk \
		--with-PATH_VGETTY=/sbin/vgetty \
		--with-PATH_GETTY=/sbin/agetty \
		--with-HTML=no \
		--with-PATH_DPSRIP=/var/spool/fax/bin/ps2fax \
		--with-PATH_IMPRIP=/usr/share/fax/psrip \
		--with-SYSVINIT=/etc/init.d \
		--with-INTERACTIVE=no || die
	
	make OPTIMIZER="${CFLAGS}" || die
}

src_install() {

	dodir /usr/{bin,sbin} /usr/lib/fax /usr/share/man /var/spool/fax \
		/var/spool/fax/{archive,client,pollq,recvq,tmp}
	chown -R uucp:uucp ${D} /var/spool/fax

	make \
		BIN=${D}/usr/bin \
		SBIN=${D}/usr/sbin \
		LIBDIR=${D}/usr/lib \
		LIB=${D}/usr/lib \
		LIBEXEC=${D}/usr/sbin \
		LIBDATA=${D}/usr/lib/fax \
		MAN=${D}/usr/share/man \
		SPOOL=${D}/var/spool/fax \
		install || die
	
	insinto /etc/init.d
	insopts -m 755
	doins etc/hylafax

	dodoc COPYRIGHT README TODO VERSION
	dohtml -r .
}
