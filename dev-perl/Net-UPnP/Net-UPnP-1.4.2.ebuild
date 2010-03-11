# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-UPnP/Net-UPnP-1.4.2.ebuild,v 1.6 2010/03/11 21:34:01 maekke Exp $

EAPI=2

MODULE_AUTHOR=SKONNO
inherit perl-module

DESCRIPTION="Perl extension for UPnP"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="virtual/perl-version"
DEPEND="${RDEPEND}"

SRC_TEST=do
