# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.1.2.1.ebuild,v 1.1 2007/03/04 03:10:14 zmedico Exp $

inherit toolchain-funcs eutils flag-o-matic multilib

DESCRIPTION="The Portage Package Management System. The primary package management and distribution system for Gentoo."
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
PROVIDE="virtual/portage"
SLOT="0"
# USE_EXPAND_HIDDEN hides ELIBC and USERLAND expansions from emerge output (see make.conf.5).
IUSE_ELIBC="elibc_glibc elibc_uclibc elibc_FreeBSD"
IUSE_USERLAND="userland_Darwin userland_GNU"
IUSE="build doc epydoc selinux linguas_pl ${IUSE_ELIBC} ${IUSE_USERLAND}"
DEPEND=">=dev-lang/python-2.3
	!build? ( >=sys-apps/sed-4.0.5 )
	epydoc? ( >=dev-python/epydoc-2.0 )"
RDEPEND=">=dev-lang/python-2.3
	!build? ( >=sys-apps/sed-4.0.5
		dev-python/python-fchksum
		!userland_Darwin? ( >=app-shells/bash-3.0 ) )
	elibc_glibc? ( >=sys-apps/sandbox-1.2.17 )
	elibc_uclibc? ( >=sys-apps/sandbox-1.2.17 )
	!userland_Darwin? ( >=app-misc/pax-utils-0.1.13 )
	userland_GNU? ( !selinux? ( >=sys-apps/coreutils-6.4 ) )
	selinux? ( >=dev-python/python-selinux-2.16 )
	doc? ( app-portage/portage-manpages )
	>=dev-python/pycrypto-2.0.1-r5"
# coreutils-6.4 rdep is for date format in emerge-webrsync #164532
SRC_ARCHIVES="http://dev.gentoo.org/~zmedico/portage/archives"

PV_PL="2.1.2"
PATCHVER_PL=""
SRC_URI="mirror://gentoo/${PN}-${PV%.*}.tar.bz2
	${SRC_ARCHIVES}/${PN}-${PV%.*}.tar.bz2
	linguas_pl? ( mirror://gentoo/${PN}-man-pl-${PV_PL}.tar.bz2
	${SRC_ARCHIVES}/${PN}-man-pl-${PV_PL}.tar.bz2 )"

PATCHVER=${PV}
if [ -n "${PATCHVER}" ]; then
	SRC_URI="${SRC_URI} mirror://gentoo/${PN}-${PATCHVER}.patch.bz2
	${SRC_ARCHIVES}/${PN}-${PATCHVER}.patch.bz2"
fi

if [ -n "${PATCHVER_PL}" ]; then
	SRC_URI="${SRC_URI} linguas_pl? ( mirror://gentoo/${PN}-man-pl-${PV_PL}${PATCHVER_PL}.patch.bz2
	${SRC_ARCHIVES}/${PN}-man-pl-${PV_PL}${PATCHVER_PL}.patch.bz2 )"
fi

S="${WORKDIR}"/${PN}-${PV%.*}
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
		epatch "${WORKDIR}/${PN}-${PATCHVER}.patch"
	fi
	einfo "Setting portage.VERSION to ${PVR} ..."
	sed -i "s/^VERSION=.*/VERSION=\"${PVR}\"/" pym/portage.py || \
		die "Failed to patch portage.VERSION"
	eend 0
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

	if use epydoc; then
		einfo "Generating api docs"
		mkdir "${WORKDIR}"/api
		local my_modules
		my_modules="$(find "${S}/pym" -name "*.py" \
			| sed -e 's:.*__init__.py$::' -e 's:\.py$::' -e "s:^${S}/pym/::" \
			 -e 's:/:.:g')" || die "error listing modules"
		PYTHONPATH="${S}/pym:${PYTHONPATH}" epydoc -o "${WORKDIR}"/api \
			-qqqqq --ignore-param-mismatch ${my_modules} || die "epydoc failed"
	fi
}

src_test() {
	./tests/runTests || \
		die "test(s) failed"
}

src_install() {
	local libdir=$(get_libdir)
	local portage_base="/usr/${libdir}/portage"
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
	use epydoc && dohtml -r "${WORKDIR}"/api

	dodir /usr/bin
	for x in ebuild emerge portageq repoman tbz2tool xpak; do
		dosym ../${libdir}/portage/bin/${x} /usr/bin/${x}
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
		dosym ../${libdir}/portage/bin/${x} /usr/sbin/${x}
	done

	dodir /etc/portage
	keepdir /etc/portage

	echo PYTHONPATH=\"${portage_base}/pym\" > "${WORKDIR}"/05portage.envd
	doenvd "${WORKDIR}"/05portage.envd
}

pkg_preinst() {
	local portage_base="/usr/$(get_libdir)/portage"
	if has livecvsportage ${FEATURES} && [ "${ROOT}" = "/" ]; then
		rm -rf "${IMAGE}"/${portage_base}/pym/*
		mv "${IMAGE}"/${portage_base}/bin/tbz2tool "${T}"
		rm -rf "${IMAGE}"/${portage_base}/bin/*
		mv "${T}"/tbz2tool "${IMAGE}"/${portage_base}/bin/
	else
		for mydir in bin pym pym/cache pym/elog_modules; do
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

	ewarn "In portage-2.1.2, installation actions do not necessarily pull in build time"
	ewarn "dependencies that are not strictly required.  This behavior is adjustable"
	ewarn "via the new --with-bdeps option that is documented in the emerge(1) man page."
	ewarn "For more information regarding this change, please refer to bug #148870."
	echo
	elog "See NEWS and RELEASE-NOTES for further changes."
	echo
	portage_docs
}
