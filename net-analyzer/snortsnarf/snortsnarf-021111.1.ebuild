# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snortsnarf/snortsnarf-021111.1.ebuild,v 1.1 2003/02/12 10:45:18 aliz Exp $

DESCRIPTION="Snort Snarf parses Snort log files, and converts them into
easy-to-read HTML files.  Expect an estimated 2:3 ratio (log file size:megs of
ram)."

HOMEPAGE="http://www.silicondefense.com/software/snortsnarf/"
MY_P="SnortSnarf-${PV}"
S=${WORKDIR}/${MY_P}
SRC_URI="http://www.silicondefense.com/software/snortsnarf/${MY_P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RDEPEND="virtual/glibc
	dev-perl/Time-modules
	dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

src_compile() {
	return 0
}

src_install () {
	PERL_V=$( perl '-V:version' | awk -F "'" '{print $2}' )

	dodoc Usage COPYING Changes README README.SISR README.nmap2html \
		new-annotation-base.xml

	dobin snortsnarf.pl nmap2html/log2db.pl nmap2html/nmap2html.pl \
		nmap2html/nmaplog-dns.pl utilities/*

	dodir /home/httpd/snortsnarf/cgi-bin
	dodir /usr/lib/perl5/site_perl/$PERL_V/SnortSnarf

	insinto /home/httpd/snortsnarf/cgi-bin
	doins cgi/*

	cp -a include/* ${D}/usr/lib/perl5/site_perl/$PERL_V
}

src_postinst() {
	setup_anns_dir.pl /var/log/snortsnarf
}
