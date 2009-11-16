# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-podlators/perl-podlators-2.2.2.ebuild,v 1.1 2009/11/16 13:10:32 tove Exp $

DESCRIPTION="Virtual for podlators"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( ~dev-lang/perl-5.10.1 ~perl-core/podlators-${PV} )"
