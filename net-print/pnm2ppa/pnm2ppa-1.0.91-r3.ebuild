# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-print/pnm2ppa/pnm2ppa-1.0.91-r3.ebuild,v 1.2 2002/04/27 23:34:20 bangert Exp $
# Note: this also d/ls the hp-ppa-howto and installs it under /usr/share/doc/${P}

# pnm2ppa is a print filter for HP's line of Winprinters which use a proprietary
# protocol called ppa (Print Performance Architecture).
# Like Winmodems, Winprinters don't have a microprocessor; your main CPU does 
# all the hard work.
# Winprinters: Hp Deskjet 710, 712, 720, 722, 820, 1000 series.
# pnm2ppa can work on its own or via lpr or pdq.

# The ebuild in general seems a bit flaky, anyone who has a ppa printer
# please check it out and tell me if it worked.

# Description of accompanying patch: install into /usr instead of /usr/local
# and use env. var. CFLAGS. Took a lot of changes though.

S=${WORKDIR}/${PN}
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.tgz
	 http://prdownloads.sourceforge.net/${PN}/howto.tgz"

HOMEPAGE="http://pnm2ppa.sourceforge.net"
DESCRIPTION="Print driver for Hp Deskjet 710, 712, 720, 722, 820, 1000 series"

# note: this doesn't depend on virtual/lpr, because it can work on its own,
# just without queueing etc. since it's not just a driver but a standalone
# executable.
DEPEND="gtk? ( x11-libs/gtk+ )
	ncurses? ( sys-libs/ncurses )"
	
RDEPEND="${DEPEND}
	app-text/enscript
	dev-util/dialog"

src_unpack() {
    
    cd ${WORKDIR}
    unpack ${P}.tgz
    cd ${S}
    unpack howto.tgz

	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
    
}

src_compile() {
    
	export CFLAGS="-DNDEBUG ${CFLAGS}"
	
    emake 	\
		CFLAGS="${CFLAGS} -DLANG_EN" || die
		
    
    cd ${S}/ppa_protocol
    emake 	\
		CFLAGS="${CFLAGS}" || die
    
    cd ${S}/ppaSet-beta1
    # This requires gtk, ncurses etc. on which we don't want to depend
    # so we simply fail if they aren't installed
    echo "The following may fail, don't pay attention to any error"
    sleep 1s

    use gtk &&	\
		make 	\
			BASEDIR=/usr/share/pnm2ppa/ppaSet	\
			BINDIR=/usr/bin	\
			PNM2PPA=/usr/bin/pnm2ppa	\
			CALIBRATE_PPA=/usr/bin/calibrate_ppa	\
			CFLAGS="${CFLAGS}" gPpaSet 
	
	use ncurses && \
		make 	\
			BASEDIR=/usr/share/pnm2ppa/ppaSet	\
			BINDIR=/usr/bin	\
			PNM2PPA=/usr/bin/pnm2ppa	\
			CALIBRATE_PPA=/usr/bin/calibrate_ppa	\
			CFLAGS="${CFLAGS}" nPpaSet

    make	\
		BASEDIR=/usr/share/pnm2ppa/ppaSet	\
		BINDIR=/usr/bin	\
		PNM2PPA=/usr/bin/pnm2ppa	\
		CALIBRATE_PPA=/usr/bin/calibrate_ppa	\
		CFLAGS="${CFLAGS}"
}

src_install () {
	
	dodir /usr/bin
	dodir /etc
	dodir /usr/share/man/man1

	make	\
		INSTALLDIR=${D}/usr/bin	\
		CONFDIR=${D}/etc	\
		MANDIR=${D}/usr/share/man/man1	\
		install || die

	exeinto /usr/bin
	doexe utils/Linux/detect_ppa utils/Linux/test_ppa
 	
	insinto /usr/share/pnm2ppa/lpd
	doins ${S}/lpd/*
	exeinto /usr/share/pnm2ppa/lpd
	doexe ${S}/lpd/lpdsetup

	insinto /usr/share/pnm2ppa/pdq
	doins ${S}/pdq/*
	
	# Interfaces for configuration of integration with lpd
	# These are not installed because we do not assume that
	# lpd, ncurses, gtk, but the sources are provided.  Thus,
	# if the headers were found they would have been built.
	cd ${S}/ppaSet-beta1
	exeinto /usr/share/pnm2ppa/ppaSet-beta1
	doexe calibration cleanHeads gammaRef install noGamma ppa.if test

	exeinto /usr/share/pnm2ppa/sample_scripts
	doexe ${S}/sample_scripts/*

	cd ${S}/pdq
	exeinto /etc/pdq/drivers/ghostscript
	doexe gs-pnm2ppa
	exeinto /etc/pdq/interfaces
	doexe dummy
	
    cd ${S}/ppaSet-beta1
	use gtk &&	\
		yes "" | make	\
			BASEDIR=${D}/usr/ppaSet	\
			BINDIR=${D}/usr/bin	\
			PNM2PPA=${D}/usr/bin/pnm2ppa	\
			CALIBRATE_PPA=${D}/usr/bin/calibrate_ppa	\
			install-g

	use ncurses && \
		yes "" | make	\
			BASEDIR=${D}/usr/ppaSet	\
			BINDIR=${D}/usr/bin	\
			PNM2PPA=${D}/usr/bin/pnm2ppa	\
			CALIBRATE_PPA=${D}/usr/bin/calibrate_ppa	\
			install-n

	yes "" | make	\
		BASEDIR=${D}/usr/ppaSet	\
		BINDIR=${D}/usr/bin	\
		PNM2PPA=${D}/usr/bin/pnm2ppa	\
		CALIBRATE_PPA=${D}/usr/bin/calibrate_ppa	\
		install
	
	rm ${D}/etc/printcap.*
	
	cd ${S}/docs/en
	dodoc CALIBRATION*txt COLOR*txt PPA*txt RELEASE*
	dodoc CREDITS INSTALL LICENSE README TODO
	
	cd sgml
	insinto /usr/share/doc/${P}
	doins *.sgml

	cd ${S}
	dohtml -r .

	#clean up
	rm -f ${D}/usr/bin/gPpaSet
	rm -f ${D}/usr/bin/nPpaSet

	dosym /usr/ppaSet/gPpaSet /usr/bin/gPpaSet
	dosym /usr/ppaSet/nPpaSet /usr/bin/nPpaSet

}

pkg_postinst() {

    einfo "
    Now, you *must* edit /etc/pnm2ppa.conf and choose (at least)
    your printer model and papersize.
    
    Run calibrate_ppa to calibrate color offsets.
    
    Read the docs in /usr/share/pnm2ppa/ to configure the printer,
    configure lpr substitutes, cups, pdq, networking etc.
    
    Note that lpr and pdq drivers *have* been installed, but if your
    config file management has /etc blocked (the default), they have
    been installed under different filenames. Read the appropriate
    Gentoo documentation for more info.
    
    Note: lpr has been configured for default papersize letter
    "
    
}
