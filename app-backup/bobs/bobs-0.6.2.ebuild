# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/bobs/bobs-0.6.2.ebuild,v 1.1 2006/05/11 16:50:44 lisa Exp $

inherit webapp eutils

DESCRIPTION="The Browsable Online Backup System"
HOMEPAGE="http://bobs.sourceforge.net/"

SRC_URI="mirror://sourceforge/bobs/${P}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="x86"

IUSE=""

DEPEND="virtual/php"

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${PF}.patch

	# Original configure looks for httpd process.  Hardwire to apache2...
	sed -e "s:\$(ps -C httpd:\$(ps -C apache2:" \
		-i 'configure' || "Autodetect of Apache user failed"
	# Slightly nasty fixup for some problems in the orig Makefile
	# Otherwise it doesn't respect that prefix given to "make install"
	sed -e "s:\$(myBOBSDATA):\$(DESTDIR)\$(myBOBSDATA):" \
		-i 'Makefile.am' || "Makefile bodge failed"
	sed -e "s:\$(top_srcdir)/mkinstalldirs\\$(myWEBDIR):\$(top_srcdir)/mkinstalldirs \$(DESTDIR)\$(myWEBDIR):" \
		-i 'inc/servers/Makefile.am' || "Makefile bodge failed"
	sed	-e "s:chown -R \$(myHTTPDUSER) \$(myWEBDIR):chown -R \$(myHTTPDUSER)\\$(DESTDIR)\$(myWEBDIR):" \
		-i 'inc/servers/Makefile.am' || "Makefile bodge failed"
	# Modify the webdir to match the webapp format
	sed -e "s:myWEBDIR=\$with_webdir/bobs:myWEBDIR=\$with_webdir:" \
		-i 'configure' || "configure bodge failed"
}

src_compile() {
	./configure \
		--with-webdir=/usr/share/webapps/${PN}/${PV}/htdocs \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	webapp_src_preinst

	make DESTDIR=${D} install || die
	keepdir /var/bobsdata/current/process/session
	keepdir /var/bobsdata/current/process/cmd
	keepdir /var/bobsdata/current/process/mounts
	webapp_configfile ${MY_HTDOCSDIR}/inc/excludes/default.excludelist
	webapp_configfile ${MY_HTDOCSDIR}/inc/config.php
	webapp_configfile ${MY_HTDOCSDIR}/inc/servers/testserver.share.ini

	dodir /var/bobsdata/incoming
	dodir /var/bobsdata/incremental

	# Why doesn't this next line work?
	chown -R root:apache ${D}/var/bobsdata/
	einfo "/var/bobsdata MUST be accessible to the apache user"

	dodoc README INSTALL TODO

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
