# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.1.1-r2.ebuild,v 1.8 2006/11/15 13:28:55 corsair Exp $

inherit toolchain-funcs eutils flag-o-matic

DESCRIPTION="The Portage Package Management System. The primary package management and distribution system for Gentoo."
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 arm hppa ia64 m68k ~mips ppc ppc-macos ppc64 s390 sh sparc x86 ~x86-fbsd"
PROVIDE="virtual/portage"
SLOT="0"
# USE_EXPAND_HIDDEN hides ELIBC and USERLAND expansions from emerge output (see make.conf.5).
IUSE_ELIBC="elibc_glibc elibc_uclibc elibc_FreeBSD"
IUSE_USERLAND="userland_Darwin userland_GNU"
IUSE="build doc selinux linguas_pl ${IUSE_ELIBC} ${IUSE_USERLAND}"
DEPEND=">=dev-lang/python-2.3
	!build? ( >=sys-apps/sed-4.0.5 )"
RDEPEND=">=dev-lang/python-2.3
	!build? ( >=sys-apps/sed-4.0.5
		dev-python/python-fchksum
		!userland_Darwin? ( >=app-shells/bash-3.0 ) )
	elibc_glibc? ( >=sys-apps/sandbox-1.2.17 )
	elibc_uclibc? ( >=sys-apps/sandbox-1.2.17 )
	!userland_Darwin? ( >=app-misc/pax-utils-0.1.13 )
	selinux? ( >=dev-python/python-selinux-2.16 )
	doc? ( app-portage/portage-manpages )
	>=dev-python/pycrypto-2.0.1-r5"
SRC_ARCHIVES="http://dev.gentoo.org/~zmedico/portage/archives"

PV_PL="2.1"
PATCHVER_PL="-r1"
SRC_URI="mirror://gentoo/${PN}-${PV}.tar.bz2
	${SRC_ARCHIVES}/${PN}-${PV}.tar.bz2
	linguas_pl? ( mirror://gentoo/${PN}-man-pl-${PV_PL}.tar.bz2
	${SRC_ARCHIVES}/${PN}-man-pl-${PV_PL}.tar.bz2 )"

PATCHVER=""
[ "${PR}" != "r0" ] && PATCHVER="-${PR}"
if [ -n "${PATCHVER}" ]; then
	SRC_URI="${SRC_URI} mirror://gentoo/${PN}-${PV}${PATCHVER}.patch.bz2
	${SRC_ARCHIVES}/${PN}-${PV}${PATCHVER}.patch.bz2"
fi

if [ -n "${PATCHVER_PL}" ]; then
	SRC_URI="${SRC_URI} linguas_pl? ( mirror://gentoo/${PN}-man-pl-${PV_PL}${PATCHVER_PL}.patch.bz2
	${SRC_ARCHIVES}/${PN}-man-pl-${PV_PL}${PATCHVER_PL}.patch.bz2 )"
fi

S="${WORKDIR}"/${PN}-${PV}
S_PL="${WORKDIR}"/${PN}-${PV_PL}

portage_docs() {
	elog ""
	elog "For help with using portage please consult the Gentoo Handbook"
	elog "at http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=3"
	elog ""
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	if [ -n "${PATCHVER}" ]; then
		cd "${S}"
		epatch "${WORKDIR}/${PN}-${PV}${PATCHVER}.patch"
	fi
	if [ "${PR}" != "r0" ]; then
		elog "Setting portage.VERSION to ${PVR} ..."
		sed -i "s/^VERSION=.*/VERSION=\"${PVR}\"/" pym/portage.py || \
			die "Failed to patch portage.VERSION"
		eend 0
	fi
	if [ -n "${PATCHVER_PL}" ]; then
		use linguas_pl && \
			epatch "${WORKDIR}/${PN}-man-pl-${PV_PL}${PATCHVER_PL}.patch"
	fi
}

src_compile() {
	append-lfs-flags

	cd "${S}"/src
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o tbz2tool tbz2tool.c || \
		die "Failed to build tbz2tool"

	if use elibc_FreeBSD; then
		cd "${S}"/src/bsd-flags
		chmod +x setup.py
		./setup.py build || die "Failed to install bsd-chflags module"
	fi
}

src_install() {
	local portage_base="/usr/lib/portage"
	cd "${S}"/cnf
	insinto /etc
	doins etc-update.conf dispatch-conf.conf make.globals
	if [ -f "make.conf.${ARCH}".diff ]; then
		patch make.conf "make.conf.${ARCH}".diff || \
			die "Failed to patch make.conf.example"
		newins make.conf make.conf.example
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
		newins make.conf make.conf.example
	fi

	if use elibc_FreeBSD; then
		cd "${S}"/src/bsd-flags
		./setup.py install --root "${D}" || \
			die "Failed to install bsd-chflags module"
	fi

	dodir ${portage_base}/bin
	exeinto ${portage_base}/bin
	# BSD and OSX need a sed wrapper so that find/xargs work properly
	if use userland_GNU; then
		rm "${S}"/bin/sed || die "Failed to remove sed wrapper"
	fi
	cd "${S}"/bin
	doexe *
	doexe "${S}"/src/tbz2tool
	dosym newins ${portage_base}/bin/donewins

	for mydir in pym pym/cache pym/elog_modules; do
		dodir ${portage_base}/${mydir}
		insinto ${portage_base}/${mydir}
		cd "${S}"/${mydir}
		doins *.py
	done

	doman "${S}"/man/*.[0-9]
	if use linguas_pl; then
		doman -i18n=pl "${S_PL}"/man/pl/*.[0-9]
		doman -i18n=pl_PL.UTF-8 "${S_PL}"/man/pl_PL.UTF-8/*.[0-9]
	fi
	dodoc "${S}"/ChangeLog
	dodoc "${S}"/NEWS
	dodoc "${S}"/RELEASE-NOTES

	dodir /usr/bin
	for x in ebuild emerge portageq repoman tbz2tool xpak; do
		dosym ../lib/portage/bin/${x} /usr/bin/${x}
	done

	dodir /usr/sbin
	local my_syms="archive-conf
		dispatch-conf
		emaint
		emerge-webrsync
		env-update
		etc-update
		fixpackages
		quickpkg
		regenworld"
	local x
	for x in ${my_syms}; do
		dosym ../lib/portage/bin/${x} /usr/sbin/${x}
	done

	dodir /etc/portage
	keepdir /etc/portage

	doenvd "${FILESDIR}"/05portage.envd
}

pkg_preinst() {
	local portage_base="/usr/lib/portage"
	if has livecvsportage ${FEATURES} && [ "${ROOT}" = "/" ]; then
		rm -rf "${IMAGE}"/${portage_base}/pym/*
		mv "${IMAGE}"/${portage_base}/bin/tbz2tool "${T}"
		rm -rf "${IMAGE}"/${portage_base}/bin/*
		mv "${T}"/tbz2tool "${IMAGE}"/${portage_base}/bin/
	else
		for mydir in pym pym/cache pym/elog_modules; do
			rm "${ROOT}"/${portage_base}/${mydir}/*.pyc >& /dev/null
			rm "${ROOT}"/${portage_base}/${mydir}/*.pyo >& /dev/null
		done
	fi
}

pkg_postinst() {
	local x

	if [ ! -f "${ROOT}/var/lib/portage/world" ] &&
	   [ -f "${ROOT}"/var/cache/edb/world ] &&
	   [ ! -h "${ROOT}"/var/cache/edb/world ]; then
		mv "${ROOT}"/var/cache/edb/world "${ROOT}"/var/lib/portage/world
		ln -s ../../lib/portage/world /var/cache/edb/world
	fi

	for x in "${ROOT}"/etc/._cfg????_make.globals; do
		# Overwrite the globals file automatically.
		[ -e "${x}" ] && mv -f "${x}" "${ROOT}etc/make.globals"
	done

	ewarn "In portage-2.1.1, emerge --newuse is now sensitive to changes in IUSE."
	ewarn "Immediately after upgrade from 2.1, users may notice a significantly larger"
	ewarn "number of packages pulled in by --newuse, but that behavior is normal."
	ewarn "For additional information regarding this change, please see bugs #116955,"
	ewarn "#144333, #144661, and #146060."
	echo
	ewarn "In portage-2.1.1-r2, the implicit RDEPEND behavior has been reverted back to"
	ewarn "the way it was in <portage-2.0.52. This change restricts implicit RDEPEND to"
	ewarn "the ebuild level, making it independent of whatever RDEPEND may or may not be"
	ewarn "defined in the inherited eclasses.  As a result, some ebuilds will get"
	ewarn "implicit RDEPEND that they did not get previously.  Also, some ebuilds will"
	ewarn "loose some implicit RDEPEND that they previously got from eclasses.  Users"
	ewarn "that sync with the rsync mirrors will have their metadata cache automatically"
	ewarn "updated on the next sync (or the next time that they run"
	ewarn "\`emerge --metadata\`).  Users of the gentoo-x86 CVS repository, in order to"
	ewarn "make the change immediately effective, will have to manually remove the"
	ewarn "entire contents of /var/cache/edb/dep/ and then run \`emerge --regen\`."
	ewarn "If necessary, please refer to bug #153591 for more information."
	echo
	elog "See NEWS and RELEASE-NOTES for further changes."
	echo
	portage_docs
}
