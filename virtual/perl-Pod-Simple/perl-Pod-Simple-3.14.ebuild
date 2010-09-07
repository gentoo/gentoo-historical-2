# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Pod-Simple/perl-Pod-Simple-3.14.ebuild,v 1.6 2010/09/07 20:32:24 tove Exp $

DESCRIPTION="Virtual for Pod-Simple"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND="|| ( ~dev-lang/perl-5.12.2 ~dev-lang/perl-5.12.1 ~perl-core/Pod-Simple-${PV} )"
