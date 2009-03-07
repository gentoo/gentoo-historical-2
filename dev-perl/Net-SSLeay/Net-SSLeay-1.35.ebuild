# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SSLeay/Net-SSLeay-1.35.ebuild,v 1.3 2009/03/07 18:05:13 armin76 Exp $

MODULE_AUTHOR=FLORA
inherit perl-module multilib

DESCRIPTION="Net::SSLeay module for perl"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/openssl
	dev-lang/perl"
DEPEND="${RDEPEND}"
#	test? ( dev-perl/Test-Exception
#		dev-perl/Test-Warn
#		dev-perl/Test-NoWarnings )"

#SRC_TEST=do

export OPTIMIZE="$CFLAGS"

src_unpack() {
	unpack ${A}
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e "s:openssl_path/lib:openssl_path/$(get_libdir):" \
		"${S}"/Makefile.PL || die
	fi
}
