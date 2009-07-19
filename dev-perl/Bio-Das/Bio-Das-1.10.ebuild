# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bio-Das/Bio-Das-1.10.ebuild,v 1.3 2009/07/19 17:33:07 tove Exp $

MODULE_AUTHOR="LDS"
inherit perl-module

DESCRIPTION="Interface to Distributed Annotation System"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

# Tests work again as of 1.10 (were broken in 1.09)
SRC_TEST="do"

DEPEND=">=virtual/perl-IO-Compress-1.0
	sci-biology/bioperl
	>=dev-perl/HTML-Parser-3
	>=dev-perl/libwww-perl-5
	>=virtual/perl-MIME-Base64-2.12"
