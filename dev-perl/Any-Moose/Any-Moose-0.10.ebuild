# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Any-Moose/Any-Moose-0.10.ebuild,v 1.2 2009/10/13 15:12:25 jer Exp $

EAPI=2

MODULE_AUTHOR=SARTAK
inherit perl-module

DESCRIPTION="Use Moose or Mouse modules"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

RDEPEND=">=dev-perl/Mouse-0.21
	virtual/perl-version"
DEPEND="${RDEPEND}"

SRC_TEST=do
