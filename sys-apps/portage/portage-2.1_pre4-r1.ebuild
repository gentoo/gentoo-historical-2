# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.1_pre4-r1.ebuild,v 1.1 2006/01/29 12:03:46 jstubbs Exp $

inherit toolchain-funcs

DESCRIPTION="The Portage Package Management System. The primary package management and distribution system for Gentoo."
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PN}-${PV}.tar.bz2 http://dev.gentoo.org/~jstubbs/releases/${PN}-${PV}.tar.bz2"
LICENSE="GPL-2"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"

SLOT="0"
IUSE="build doc selinux"
DEPEND=">=dev-lang/python-2.3"
RDEPEND="!build? ( >=sys-apps/sed-4.0.5 \
					dev-python/python-fchksum \
					>=dev-lang/python-2.3 \
					userland_GNU? ( sys-apps/debianutils ) \
					>=app-shells/bash-2.05a ) \
		!userland_Darwin? ( app-misc/pax-utils sys-apps/sandbox ) \
		selinux? ( >=dev-python/python-selinux-2.15 ) \
		doc? ( app-portage/portage-manpages )
		>=dev-python/pycrypto-2.0.1"

PROVIDE="virtual/portage"

S=${WORKDIR}/${PN}-${PV}


src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/2.1_pre4-r1.patch
}

src_compile() {
	python -O -c "import compileall; compileall.compile_dir('${S}/pym')"

	cd "${S}"/src
	$(tc-getCC) ${CFLAGS} -o tbz2tool tbz2tool.c

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

	dodir /usr/lib/portage/pym
	insinto /usr/lib/portage/pym
	cd "${S}"/pym
	doins *

	dodir /usr/lib/portage/pym/cache
	insinto /usr/lib/portage/pym/cache
	cd "${S}"/pym/cache
	doins *

	dodir /usr/lib/portage/pym/elog_modules
	insinto /usr/lib/portage/pym/elog_modules
	cd "${S}"/pym/elog_modules
	doins *

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

	doenvd ${FILESDIR}/05portage.envd
}

pkg_preinst() {
	if has livecvsportage ${FEATURES} && [ "${ROOT}" = "/" ]; then
		rm -rf ${IMAGE}/usr/lib/portage/pym/*
		mv ${IMAGE}/usr/lib/portage/bin/tbz2tool ${T}
		rm -rf ${IMAGE}/usr/lib/portage/bin/*
		mv ${T}/tbz2tool ${IMAGE}/usr/lib/portage/bin/
	else
		rm /usr/lib/portage/pym/*.pyc >& /dev/null
		rm /usr/lib/portage/pym/*.pyo >& /dev/null
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
	einfo "The default cache format has changed beginning with this"
	einfo "version. Before using emerge, run \`emerge --metadata\` to"
	einfo "restore portage's local cache."
	echo
	einfo "Flag ordering has changed for \`emerge --pretend --verbose\`."
	einfo "Add EMERGE_DEFAULT_OPTS=\"--alphabetical\" to /etc/make.conf"
	einfo "to restore the previous ordering."
	echo
	einfo "See NEWS and RELEASE-NOTES for further changes."
}
