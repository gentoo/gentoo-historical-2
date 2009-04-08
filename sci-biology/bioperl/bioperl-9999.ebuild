# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl/bioperl-9999.ebuild,v 1.2 2009/04/08 20:45:57 weaver Exp $

EAPI="2"

inherit perl-module subversion

SUBPROJECTS="+db +network +run"

DESCRIPTION="Perl tools for bioinformatics - Core modules"
HOMEPAGE="http://www.bioperl.org/"
SRC_URI=""
ESVN_REPO_URI="svn://code.open-bio.org/bioperl/bioperl-live/trunk"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-minimal graphviz ${SUBPROJECTS}"

DEPEND="virtual/perl-Module-Build
	dev-perl/Data-Stag
	dev-perl/libwww-perl
	!minimal? (
		dev-perl/Ace
		dev-perl/Bio-ASN1-EntrezGene
		dev-perl/Spreadsheet-ParseExcel
		dev-perl/Spreadsheet-WriteExcel
		>=dev-perl/XML-SAX-0.15
		dev-perl/Graph
		dev-perl/SOAP-Lite
		dev-perl/Array-Compare
		dev-perl/SVG
		dev-perl/XML-Simple
		dev-perl/XML-Parser
		dev-perl/XML-Twig
		>=dev-perl/HTML-Parser-3.60
		>=dev-perl/XML-Writer-0.4
		dev-perl/Clone
		dev-perl/XML-DOM
		dev-perl/set-scalar
		dev-perl/XML-XPath
		dev-perl/XML-DOM-XPath
		dev-perl/Algorithm-Munkres
		dev-perl/Data-Stag
		dev-perl/Math-Random
		dev-perl/PostScript
		dev-perl/Convert-Binary-C
		dev-perl/SVG-Graph
	)
	graphviz? ( dev-perl/GraphViz )"

RDEPEND="${DEPEND}"
PDEPEND="
	db? ( >=sci-biology/bioperl-db-${PV} )
	network? ( >=sci-biology/bioperl-network-${PV} )
	run? ( >=sci-biology/bioperl-run-${PV} )"

S="${WORKDIR}/BioPerl-${PV}"

src_configure() {
	sed -i -e '/add_post_install_script.*symlink_script.pl/d' \
		-e "/'CPAN' *=> *1.81/d" "${S}/Build.PL" || die
	if use minimal && use graphviz; then die "USE flags minimal and graphviz cannot be used together"; fi
	perl-module_src_configure
}

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
