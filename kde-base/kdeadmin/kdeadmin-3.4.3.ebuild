# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin/kdeadmin-3.4.3.ebuild,v 1.2 2005/11/21 17:51:47 gustavoz Exp $

inherit kde-dist

DESCRIPTION="KDE administration tools (user manager, etc.)"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc sparc ~x86"
IUSE=""

DEPEND="~kde-base/kdebase-${PV}"

src_compile() {
	# we only want to compile the lilo config module on x86, but there we want to make sure it's
	# always compiled to ensure consistent behaviour of the package across both lilo and grub systems,
	# because configure when left to its own devices will build lilo-config or not basd on whether
	# lilo is present in the path.
	# so, we make configure build it by removing the configure.in.in file that checks for
	# lilo's presense
	if use x86; then
		echo > ${S}/lilo-config/configure.in.in
		make -f admin/Makefile.common || die
	fi

	export DO_NOT_COMPILE="${DO_NOT_COMPILE} ksysv"

	kde_src_compile
}
