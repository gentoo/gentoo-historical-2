# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-CGI/perl-CGI-3.49.ebuild,v 1.11 2011/01/22 10:08:10 tove Exp $

DESCRIPTION="Virtual for CGI"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x64-macos"
IUSE=""

RDEPEND="|| ( ~dev-lang/perl-5.12.3 ~dev-lang/perl-5.12.2 ~perl-core/CGI-${PV} )"
