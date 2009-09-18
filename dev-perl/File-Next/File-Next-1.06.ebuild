# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Next/File-Next-1.06.ebuild,v 1.3 2009/09/18 18:31:37 tove Exp $

EAPI=2

MODULE_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="File::Next is an iterator-based module for finding files"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="virtual/perl-File-Spec
	virtual/perl-Test-Simple"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
