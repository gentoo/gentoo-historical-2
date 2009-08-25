# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Markdown/Text-Markdown-1.0.25.ebuild,v 1.1 2009/08/25 19:07:19 robbat2 Exp $

MODULE_AUTHOR=BOBTFISH
#MODULE_A=${P}.tgz
inherit perl-module

DESCRIPTION="Convert MultiMarkdown syntax to (X)HTML"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-lang/perl
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-Text-Balanced"

DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple
		dev-perl/Text-Diff
		dev-perl/List-MoreUtils
		dev-perl/File-Slurp
		dev-perl/Test-Exception )"
#		dev-perl/Test-Pod
#		dev-perl/Test-Pod-Coverage

SRC_TEST=do
mydoc="Readme.text Todo"

src_install() {
	perl-module_src_install
	newbin script/Markdown.pl markdown || die
	# Removed
	#newbin script/MultiMarkdown.pl multimarkdown || die
}
