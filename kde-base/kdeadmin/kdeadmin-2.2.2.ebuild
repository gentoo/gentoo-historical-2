# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin/kdeadmin-2.2.2.ebuild,v 1.14 2003/02/13 12:25:41 vapier Exp $
inherit kde-dist

IUSE="pam"
DESCRIPTION="KDE $PV - administration tools"
KEYWORDS="x86 sparc "

newdepend ">=app-arch/rpm-3.0.5
	dev-libs/popt
	pam? ( >=sys-libs/pam-0.72 )"

src_compile() {
	kde_src_compile myconf
	use pam		&& myconf="$myconf --with-pam"		|| myconf="$myconf --without-pam"
	kde_src_compile configure make
}
