# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/policycoreutils/policycoreutils-1.12-r2.ebuild,v 1.1 2004/07/06 21:34:02 pebenito Exp $

IUSE="build"

inherit eutils

EXTRAS_VER="1.5"

DESCRIPTION="SELinux core utilites"
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

	cd ${S2}
	epatch ${FILESDIR}/runscript-selinux.diff

	cd ${S}
	epatch ${FILESDIR}/policycoreutils-1.10-genhomedircon-reverse.diff

	# Change script paths POLICYDIR
	sed -i -e "s:/etc/security/selinux/src/policy/:${POLICYDIR}:g" ${S}/scripts/genhomedircon

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
