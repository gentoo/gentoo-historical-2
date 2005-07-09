# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl-run/bioperl-run-1.2.2.ebuild,v 1.5 2005/07/09 22:56:10 swegener Exp $

inherit perl-module eutils

DESCRIPTION="A collection of tools for bioinformatics, genomics and life science research: subset required to run analyses"
HOMEPAGE="http://www.bioperl.org/"
#SRC_URI="http://www.cpan.org/modules/by-module/Bio/${P}.tar.gz"
SRC_URI="http://www.bioperl.org/ftp/DIST/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="
	dev-perl/Algorithm-Diff
	perl-core/File-Temp
	dev-perl/IO-String
	dev-perl/XML-Parser"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove interactiveness
	epatch ${FILESDIR}/bioperl-run-Pise-test-patch.diff
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

}
