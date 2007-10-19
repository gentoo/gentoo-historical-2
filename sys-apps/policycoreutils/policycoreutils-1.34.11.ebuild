# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/policycoreutils/policycoreutils-1.34.11.ebuild,v 1.2 2007/10/19 14:57:32 pebenito Exp $

IUSE="nls"

inherit eutils python

EXTRAS_VER="1.18"
SEMNG_VER="1.10"
SELNX_VER="1.34"

# BUGFIX_PATCH="${FILESDIR}/policycoreutils-1.30.6.diff"

DESCRIPTION="SELinux core utilities"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz
	mirror://gentoo/policycoreutils-extra-${EXTRAS_VER}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86"

RDEPEND=">=sys-libs/libselinux-${SELNX_VER}
	>=sys-libs/glibc-2.4
	sys-libs/pam
	=sys-libs/libsemanage-${SEMNG_VER}*"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S2=${WORKDIR}/policycoreutils-extra

src_unpack() {
	unpack ${A}
	cd "${S}"

	[ ! -z "${BUGFIX_PATCH}" ] && epatch "${BUGFIX_PATCH}"

	# This warning makes no sense, in this context
	sed -i -e '/FILE/ s/;/=NULL;/' "${S}/audit2why/audit2why.c" \
		|| die "audit2why sed failed"

	# rlpkg is more useful than fixfiles
	sed -i -e '/^all/s/fixfiles//' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 1 failed"
	sed -i -e '/fixfiles/d' "${S}/scripts/Makefile" \
		|| die "fixfiles sed 2 failed"

	local SUBDIRS="`cd ${S} && find -type d | cut -d/ -f2`"

	if ! useq nls; then
		for i in ${SUBDIRS}; do
			# disable locale stuff
			sed -i -e s/-DUSE_NLS// "${S}/${i}/Makefile" \
				|| die "${i} NLS sed failed"
		done
	fi

	# Gentoo Fixes
	for i in ${SUBDIRS}; do
		sed -i -e "s:-Wall:-Wall ${CFLAGS}:g" \
			-e '/^AUDITH/d' \
			"${S}/${i}/Makefile" \
			|| die "${i} Makefile CFLAGS fix failed."

		# disable audit support because the required version
		# in portage does not exist yet
	done
}

src_compile() {
	python_version

	einfo "Compiling policycoreutils"
	emake -C "${S}" PYLIBVER="python${PYVER}" || die
	einfo "Compiling policycoreutils-extra"
	emake -C "${S2}" || die
}

src_install() {
	python_version

	einfo "Installing policycoreutils"
	make DESTDIR="${D}" -C "${S}" PYLIBVER="python${PYVER}" install || die
	einfo "Installing policycoreutils-extra"
	make DESTDIR="${D}" -C "${S2}" install || die

	# remove redhat-style init script
	rm -fR "${D}/etc/rc.d"

	# compatibility symlink
	dosym /sbin/setfiles /usr/sbin/setfiles

	if has_version '<sys-libs/pam-0.99'; then
		# install compat pam.d entries
		# for older pam
		make DESTDIR="${D}" -C "${S2}/pam.d" install || die
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}usr/lib/python${PYVER}/site-packages"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}usr/lib/python${PYVER}/site-packages"
}
