# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups/cups-1.1.18-r4.ebuild,v 1.6 2003/07/16 14:31:38 pvdabeel Exp $

IUSE="ssl slp pam"

DESCRIPTION="The Common Unix Printing System"
HOMEPAGE="http://www.cups.org"

S=${WORKDIR}/${P}
SRC_URI="ftp://ftp.easysw.com/pub/cups/${PV}/${P}-source.tar.bz2"
PROVIDE="virtual/lpr"

DEPEND="virtual/glibc
	pam? ( >=sys-libs/pam-0.75 )
	ssl? ( >=dev-libs/openssl-0.9.6b )
	slp? ( >=net-libs/openslp-1.0.4 )
	>=media-libs/libpng-1.2.1
	>=media-libs/tiff-3.5.5
	>=media-libs/jpeg-6b
	usb? ( >=sys-apps/hotplug-20020401-r1 )"
RDEPEND="${DEPEND} !virtual/lpr"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc alpha hppa"

inherit flag-o-matic
filter-flags -fomit-frame-pointer

src_unpack() {
	unpack ${A}
	cd ${S}

	#make sure libcupsimage gets linked with libjpeg 
	patch -p0 < ${FILESDIR}/configure-jpeg-buildfix-1.1.15.diff || die
	patch -p1 < ${FILESDIR}/disable-strip.patch || die

#	bzip2 -dc ${DISTDIR}/${PPATCH}.diff.bz2 | patch -p1 || die
	WANT_AUTOCONF_2_5=1 autoconf || die

	#known problem, probably will be fixed next release //woodchip; #9188
	#covered by above patch...
#	cd pdftops && cp Makefile Makefile.orig
#	sed -e 's|FTFont.o||' \
#		-e 's|SFont.o||' \
#		-e 's|T1Font.o||' \
#		-e 's|TTFont.o||' Makefile.orig > Makefile
}

src_compile() {
	local myconf
	use pam || myconf="${myconf} --disable-pam"
	use ssl || myconf="${myconf} --disable-ssl"
        use slp || myconf="${myconf} --disable-slp"

	./configure \
		--with-cups-user=lp \
		--with-cups-group=lp \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	make || die "compile problem"

}

src_install() {
	dodir /var/spool /var/log/cups /etc/cups

	make \
	LOCALEDIR=${D}/usr/share/locale \
	DOCDIR=${D}/usr/share/cups/docs \
	REQUESTS=${D}/var/spool/cups \
	SERVERBIN=${D}/usr/lib/cups \
	DATADIR=${D}/usr/share/cups \
	INCLUDEDIR=${D}/usr/include \
	AMANDIR=${D}/usr/share/man \
	PMANDIR=${D}/usr/share/man \
	MANDIR=${D}/usr/share/man \
	SERVERROOT=${D}/etc/cups \
	LOGDIR=${D}/var/log/cups \
	SBINDIR=${D}/usr/sbin \
	PAMDIR=${D}/etc/pam.d \
	EXEC_PREFIX=${D}/usr \
	LIBDIR=${D}/usr/lib \
	BINDIR=${D}/usr/bin \
	bindir=${D}/usr/bin \
	INITDIR=${D}/etc \
	PREFIX=${D} \
	install || die "install problem"

	dodoc {CHANGES,CREDITS,ENCRYPTION,LICENSE,README}.txt
	dosym /usr/share/cups/docs /usr/share/doc/${PF}/html

	fowners lp.root /usr/bin/lppasswd
	fperms 4755 /usr/bin/lppasswd

	# cleanups
	rm -rf ${D}/etc/init.d
	rm -rf ${D}/etc/pam.d
	rm -rf ${D}/etc/rc*
	rm -rf ${D}/usr/share/man/cat*
	rm -rf ${D}/etc/cups/{certs,interfaces,ppd}
	rm -rf ${D}/var

	mv ${D}/etc/cups/cupsd.conf ${D}/etc/cups/cupsd.conf.orig
	sed -e "s:^#\(DocumentRoot\).*:\1 /usr/share/cups/docs:" \
		-e "s:^#\(SystemGroup\).*:\1 lp:" \
		-e "s:^#\(User\).*:\1 lp:" \
		-e "s:^#\(Group\).*:\1 lp:" \
		${D}/etc/cups/cupsd.conf.orig > ${D}/etc/cups/cupsd.conf
	rm -f ${D}/etc/cups/cupsd.conf.orig

	# foomatic cups filters
	exeinto /usr/lib/cups/filter
	doexe ${FILESDIR}/cupsomatic
	doexe ${FILESDIR}/foomatic-gswrapper

	insinto /etc/pam.d ; newins ${FILESDIR}/cups.pam cups
	exeinto /etc/init.d ; newexe ${FILESDIR}/cupsd.rc6 cupsd
	insinto /etc/xinetd.d ; newins ${FILESDIR}/cups.xinetd cups-lpd

	insinto /etc/cups; newins ${FILESDIR}/cupsd.conf-1.1.18 cupsd.conf
}

pkg_postinst() {
	install -d -m0755 ${ROOT}/var/log/cups
	install -d -m0755 ${ROOT}/var/spool
	install -m0700 -o lp -d ${ROOT}/var/spool/cups
	install -m1700 -o lp -d ${ROOT}/var/spool/cups/tmp
	install -m0711 -o lp -d ${ROOT}/etc/cups/certs
	install -d -m0755 ${ROOT}/etc/cups/{interfaces,ppd}

	einfo
	einfo "emerge >=app-text/ghostscript-7.05-r1 if you need to print"
	einfo "to a non-postscript printer(after cups itself! even if it's"
	einfo "already installed!)"
	einfo
}
