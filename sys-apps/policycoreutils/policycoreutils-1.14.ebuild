# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/policycoreutils/policycoreutils-1.14.ebuild,v 1.5 2004/09/06 01:19:28 pebenito Exp $

IUSE="build"

inherit eutils

EXTRAS_VER="1.7"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz
	mirror://gentoo/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND=">=sys-libs/libselinux-${PV}
	sys-devel/gettext
	!build? ( sys-libs/pam )"

S2=${WORKDIR}/policycoreutils-extra

src_unpack() {
	unpack ${A}

	cd ${S}
	# fix genhomedircon starting uid
	sed -i -e '/^STARTING_UID/s/100/1000/' ${S}/scripts/genhomedircon

	# add compatibility for number of genhomedircon command line args
	epatch ${FILESDIR}/policycoreutils-1.14-genhomedircon-compat.diff

	# fix up to accept Gentoo CFLAGS
	local SUBDIRS="`cd ${S} && find -type d | cut -d/ -f2`"
	for i in ${SUBDIRS}; do
		sed -i -e "s:-Wall:-Wall ${CFLAGS}:g" ${S}/${i}/Makefile \
			|| die "${i} Makefile CFLAGS fix failed."
	done
}

src_compile() {
	if use build; then
		einfo "Compiling setfiles"
		emake -C ${S}/setfiles || die
	else
		einfo "Compiling policycoreutils"
		emake -C ${S} || die
		einfo "Compiling policycoreutils-extra"
		emake -C ${S2} || die
	fi
}

src_install() {
	if use build; then
		dosbin ${S}/setfiles/setfiles
	else
		einfo "Installing policycoreutils"
		make DESTDIR="${D}" -C ${S} install || die
		einfo "Installing policycoreutils-extra"
		make DESTDIR="${D}" -C ${S2} install || die
	fi
}
