# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# /space/gentoo/cvsroot/gentoo-x86/sys-apps/gawk/gawk-3.1.0-r1.ebuild,v 1.1 2002/03/12 13:42:56 seemant Exp

DESCRIPTION="The Internet News daemon, fully featured NNTP server"
SRC_URI="ftp://ftp.isc.org/isc/inn/inn-${PV}.tar.gz"
HOMEPAGE="http://www.isc.org/products/INN"

DEPEND="virtual/glibc
	app-crypt/gnupg
	tcltk? ( dev-lang/tcl )
	ssl? ( dev-libs/openssl )"

src_compile() {
	local myconf
	use tcltk && myconf="${myconf} --with-tcl"
	use ssl && myconf="${myconf} --with-openssl"

	./configure --prefix=/usr/lib/news \
		--libexecdir=/usr/lib/awk \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-etc-dir=/etc/news \
		--with-db-dir=/var/spool/news \
		--with-spool-dir=/var/spool/news \
		--with-log-dir=/var/log/news \
		--with-run-dir=/var/run \
		--with-tmp-path=/tmp \
		--host=${CHOST}  \
		--enable-libtool \
		--enable-tagged-hash \
		--with-gnu-ld \
		--with-perl --with-python \
		${myconf} || die

	OLD_P=${P}
	unset P
	emake || die
	P=${OLD_P}
}

src_install() {
	OLD_P=${P}
	unset P
	make prefix=${D}/usr/lib/news \
		PATHETC=${D}/etc/news \
		PATHMAN=${D}/usr/share/man \
		PATHLIB=${D}/usr/lib/news/lib \
		PATHCONTROL=${D}/usr/lib/news/bin/control \
		PATHFILTER=${D}/usr/lib/news/bin/filter \
		PATHRUN=${D}/var/run \
		PATHLOG=${D}/var/log/news \
		PATHDB=${D}/var/spool/news \
		PATHSPOOL=${D}/var/spool/news \
		PATHTMP=${D}/tmp \
		MAN1=${D}/usr/share/man/man1 \
		MAN3=${D}/usr/share/man/man3 \
		MAN5=${D}/usr/share/man/man5 \
		MAN8=${D}/usr/share/man/man8 \
		install || die
	P=${OLD_P}

	dodoc CONTRIBUTORS ChangeLog HACKING HISTORY INSTALL LICENSE
	dodoc MANIFEST NEWS README*
	dodoc doc/control-messages doc/sample-control

	dodir /etc/init.d
	cp ${FILESDIR}/innd ${D}/etc/init.d
}
