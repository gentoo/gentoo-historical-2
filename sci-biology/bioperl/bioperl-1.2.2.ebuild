# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl/bioperl-1.2.2.ebuild,v 1.6 2005/07/09 22:57:34 swegener Exp $

inherit perl-module eutils

DESCRIPTION="A collection of tools for bioinformatics, genomics and life science research"
HOMEPAGE="http://www.bioperl.org/"
#SRC_URI="http://www.cpan.org/modules/by-module/Bio/${P}.tar.gz"
SRC_URI="http://www.bioperl.org/ftp/DIST/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="mysql gd"

DEPEND="perl-core/File-Temp
	dev-perl/HTML-Parser
	dev-perl/IO-String
	dev-perl/IO-stringy
	dev-perl/SOAP-Lite
	perl-core/Storable
	dev-perl/XML-DOM
	dev-perl/XML-Parser
	dev-perl/XML-Writer
	dev-perl/XML-Twig
	dev-perl/libxml-perl
	dev-perl/libwww-perl
	dev-perl/Graph
	dev-perl/Text-Shellwords
	gd? ( >=dev-perl/GD-1.32-r1 )
	mysql? ( >=dev-perl/DBD-mysql-2.1004-r3 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove interactiveness
	use mysql && epatch ${FILESDIR}/biodbgff-enable-${PV}.patch
	# want man pages in addition to perldoc documentation??
	#epatch ${FILESDIR}/domanpages-${PV}.patch
}

src_compile() {
	# there's a test to run for BioGFFDB if using mysql
	perl-module_src_compile || die "compile failed"
	# make test
##	perl-module_src_test || die "src test failed"
}

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
	# get the bptutorial installed and executeable
	dodir /usr/bin
	dosym /usr/lib/perl5/site_perl/5.8.0/bptutorial.pl /usr/bin/bptutorial.pl
	fperms +x /usr/lib/perl5/site_perl/5.8.0/bptutorial.pl

	# bioperl scripts and examples
	einfo 'Adding bioperl examples and scripts to /usr/share/...'
	dodir /usr/share/${PF}/scripts
	#insinto /usr/share/${PF}/scripts
	cd ${S}/scripts/
	tar cf - ./ | ( cd ${D}/usr/share/${PF}/scripts; tar xf -)
	dodir /usr/share/${PF}/examples
	cd ${S}/examples/
	tar cf - ./ | ( cd ${D}/usr/share/${PF}/examples; tar xf -)
	cd ${S}

	# some pods in maindir
	eval `perl '-V:installsitelib'`
	MY_SITE_LIB=${installsitelib}
	insinto ${MY_SITE_LIB}
	doins biodatabases.pod  biodesign.pod  bioperl.pod  bioscripts.pod
}
