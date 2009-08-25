# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-MIME-Base64/perl-MIME-Base64-3.08.ebuild,v 1.2 2009/08/25 10:56:49 tove Exp $

DESCRIPTION="Virtual for MIME-Base64"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~sparc ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.10.1 ~perl-core/MIME-Base64-${PV} )"
