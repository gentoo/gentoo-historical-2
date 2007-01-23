# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Template-Toolkit/Template-Toolkit-2.15-r1.ebuild,v 1.11 2007/01/23 00:20:40 kloeri Exp $

inherit perl-module

DESCRIPTION="The Template Toolkit"
SRC_URI="mirror://cpan/authors/id/A/AB/ABW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~abw/${P}/"
IUSE="xml gd mysql postgres latex"
SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="alpha amd64 ~ia64 ppc ~ppc64 sparc ~x86"

DEPEND="dev-perl/text-autoformat
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	>=dev-perl/AppConfig-1.55
	dev-lang/perl"
PDEPEND="dev-perl/text-autoformat
	xml? ( dev-perl/Template-XML )
	gd? ( dev-perl/Template-GD )
	mysql? ( dev-perl/Template-DBI )
	latex? ( dev-perl/Template-Latex )
	postgres? ( dev-perl/Template-DBI )"

#The installer tries to install to /usr/local/tt2...,
#and asks for user input, so we change myconf to ensure that
# 1) make install doesn't violate the sandbox rule
# 2) perl Makefile.pl just uses reasonable defaults, and doesn't ask for input
myconf="${myconf} TT_PREFIX=${D}/usr/share/template-toolkit2"
myconf="${myconf} TT_IMAGES=/usr/share/template-toolkit2/images"
myconf="${myconf} TT_ACCEPT='y'"

mydoc="README Changes"

#  You have version $Template::VERSION of the Template Toolkit installed.
#
#    There are some minor incompatabilities between version 1 and 2
#    of the Template Toolkit which you should be aware of.  Installing
#    this version will overwrite your version $Template::VERSION files
#    unless you take measures to install one or the other version in a
#    different location (i.e. perl Makefile.PL PREFIX=/other/path).  
#
#    Please consult the README and Changes file for further details.
#    Most of the changes are in the more obscure features and
#    directives so hopefully you will find the upgrade process fairly
#    painless.  If you're feeling brave, then answer 'y', otherwise 'n'.

