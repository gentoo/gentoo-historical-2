# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.1_pre6-r5.ebuild,v 1.2 2006/03/23 03:27:23 zmedico Exp $

inherit toolchain-funcs

DESCRIPTION="The Portage Package Management System. The primary package management and distribution system for Gentoo."
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PN}-${PV}.tar.bz2 http://dev.gentoo.org/~zmedico/portage/archives/${PN}-${PV}.tar.bz2"
LICENSE="GPL-2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"

SLOT="0"
IUSE="build doc selinux"
DEPEND=">=dev-lang/python-2.3"
RDEPEND="!build? ( >=sys-apps/sed-4.0.5 \
					dev-python/python-fchksum \
					>=dev-lang/python-2.3 \
					userland_GNU? ( sys-apps/debianutils ) \
					>=app-shells/bash-2.05a ) \
		!userland_Darwin? ( >=app-misc/pax-utils-0.1.10 sys-apps/sandbox ) \
		selinux? ( >=dev-python/python-selinux-2.15 ) \
		doc? ( app-portage/portage-manpages )
		>=dev-python/pycrypto-2.0.1-r4"

PROVIDE="virtual/portage"

S=${WORKDIR}/${PN}-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	local my_patches="1000_r2849_quiet_spinner.patch
		1010_r2854_obey_keeptemp.patch
		1020_r2857_bug_54040_resume_tree.patch
		1030_r2860_exec_stack_no_ppc64.patch
		1040_r2861_cache_cleanse.patch
		1050_r2862_ebuild_unmerge.patch
		1060_r2863_bug_125919_find_compat.patch
		1070_r2864_bug_125993_mergelist_keyerror.patch
		1080_r2865_bug_125942_postinst_env.patch
		1090_r2892_bug_126111_global_updates_stdout.patch
		1100_r2890_bug_126120_applied_useflags.patch
		1110_r2947_bug_126711_selinux_context.patch
		1120_r2952_bug_126756_nocolor_ebuild.patch
		1130_r2942_inst_uid_gid_defaults.patch
		1140_r2963_bug_126711_sandbox.patch"
	for patch_name in ${my_patches}; do
		einfo "Applying ${patch_name} ..."
		patch -p0 --no-backup-if-mismatch < "${FILESDIR}"/${PV}/${patch_name} >/dev/null || die "Failed to apply patch"
	done
	einfo "Setting portage.VERSION to ${PVR} ..."
	sed -i "s/^VERSION=.*/VERSION=\"${PVR}\"/" pym/portage.py || die "Failed to patch portage.VERSION"
}

src_compile() {
	python -O -c "import compileall; compileall.compile_dir('${S}/pym')"

	cd "${S}"/src
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o tbz2tool tbz2tool.c || die "Failed to build tbz2tool"

	if ! use userland_Darwin; then
		cd "${S}"/src/python-missingos
		chmod +x setup.py
		./setup.py build || die "Failed to build missingos module"
	fi

	if use elibc_FreeBSD; then
		cd "${S}"/src/bsd-flags
		chmod +x setup.py
		./setup.py build || die "Failed to install bsd-chflags module"
	fi
}

src_install() {
	cd "${S}"/cnf
	insinto /etc
	doins etc-update.conf dispatch-conf.conf make.globals
	if [ -f "make.conf.${ARCH}" ]; then
		newins make.conf.${ARCH} make.conf.example
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
		newins make.conf make.conf.example
	fi

	if ! use userland_Darwin; then
		cd "${S}"/src/python-missingos
		./setup.py install --root ${D} || die "Failed to install missingos module"
	fi

	if use elibc_FreeBSD; then
		cd "${S}"/src/bsd-flags
		./setup.py install --root ${D} || die "Failed to install bsd-chflags module"
	fi

	dodir /usr/lib/portage/bin
	exeinto /usr/lib/portage/bin
	cd "${S}"/bin
	doexe *
	doexe "${S}"/src/tbz2tool
	dosym newins /usr/lib/portage/bin/donewins

	for mydir in pym pym/cache pym/elog_modules; do
		dodir /usr/lib/portage/${mydir}
		insinto /usr/lib/portage/${mydir}
		cd "${S}"/${mydir}
		doins *.py *.pyo
	done

	doman "${S}"/man/*.[0-9]
	dodoc "${S}"/ChangeLog
	dodoc "${S}"/NEWS
	dodoc "${S}"/RELEASE-NOTES

	dodir /usr/bin
	for x in ebuild emerge portageq repoman tbz2tool xpak; do
		dosym ../lib/portage/bin/${x} /usr/bin/${x}
	done

	dodir /usr/sbin
	for x in archive-conf dispatch-conf emaint emerge-webrsync env-update etc-update fixpackages quickpkg regenworld; do
		dosym ../lib/portage/bin/${x} /usr/sbin/${x}
	done

	dodir /etc/portage
	keepdir /etc/portage

	doenvd "${FILESDIR}"/05portage.envd
}

pkg_preinst() {
	if has livecvsportage ${FEATURES} && [ "${ROOT}" = "/" ]; then
		rm -rf ${IMAGE}/usr/lib/portage/pym/*
		mv ${IMAGE}/usr/lib/portage/bin/tbz2tool ${T}
		rm -rf ${IMAGE}/usr/lib/portage/bin/*
		mv ${T}/tbz2tool ${IMAGE}/usr/lib/portage/bin/
	else
		for mydir in pym pym/cache pym/elog_modules; do
			rm /usr/lib/portage/${mydir}/*.pyc >& /dev/null
			rm /usr/lib/portage/${mydir}/*.pyo >& /dev/null
		done
	fi
}

pkg_postinst() {
	local x

	if [ ! -f "${ROOT}/var/lib/portage/world" ] &&
	   [ -f ${ROOT}/var/cache/edb/world ] &&
	   [ ! -h ${ROOT}/var/cache/edb/world ]; then
		mv ${ROOT}/var/cache/edb/world ${ROOT}/var/lib/portage/world
		ln -s ../../lib/portage/world /var/cache/edb/world
	fi

	for x in ${ROOT}etc/._cfg????_make.globals; do
		# Overwrite the globals file automatically.
		[ -e "${x}" ] && mv -f "${x}" "${ROOT}etc/make.globals"
	done

	ewarn "This series contains a completely rewritten caching framework."
	ewarn "If you are using any cache modules (such as the CDB cache"
	ewarn "module) portage will not work until they have been disabled."
	echo
	einfo "The default cache format has changed between 2.0.x and 2.1"
	einfo "versions. If you have upgraded from 2.0.x, before using"
	einfo "emerge, run \`emerge --metadata\` to restore portage's local"
	einfo "cache."
	echo
	einfo "Flag ordering has changed for \`emerge --pretend --verbose\`."
	einfo "Add EMERGE_DEFAULT_OPTS=\"--alphabetical\" to /etc/make.conf"
	einfo "to restore the previous ordering."
	echo
	einfo "See NEWS and RELEASE-NOTES for further changes."
}
