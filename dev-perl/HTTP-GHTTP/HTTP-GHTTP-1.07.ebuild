# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-GHTTP/HTTP-GHTTP-1.07.ebuild,v 1.13 2003/06/21 21:36:36 drobbins Exp $

inherit perl-module

DESCRIPTION="simple interface to the Gnome project's libghttp"
SRC_URI="http://cpan.valueclick.com/modules/by-module/HTTP/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/HTTP/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

newdepend ">=gnome-base/gnome-libs-1.4.1.2-r1
	>=gnome-base/libghttp-1.0.9-r1"

mydoc="TODO"
