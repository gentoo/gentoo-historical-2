# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/systemconfigurator/systemconfigurator-2.0.9.ebuild,v 1.4 2004/04/30 11:06:16 dholm Exp $

inherit perl-module
DESCRIPTION="Provide a consistant API for the configuration of system related items"
HOMEPAGE="http://sisuite.org/systemconfig/"
SRC_URI="mirror://sourceforge/systemconfig/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND="dev-lang/perl
	dev-perl/AppConfig"
