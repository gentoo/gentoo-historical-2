# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/myth.eclass,v 1.9 2005/02/27 10:59:52 eradicator Exp $
#
# Author: Daniel Ahlberg <aliz@gentoo.org>
#

inherit multilib toolchain-funcs

ECLASS=myth
INHERITED="${INHERITED} ${ECLASS}"
IUSE="${IUSE} nls debug"

EXPORT_FUNCTIONS src_unpack src_compile src_install

myth_src_unpack() {
	if [ "${PN}" == "mythfrontend" ]; then
		local package="mythtv"
	else
		local package="${PN}"
	fi

	unpack ${A} ; cd ${S}

	sed -e "s:PREFIX = .*:PREFIX = /usr:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE = .*:QMAKE_CXXFLAGS_RELEASE = ${CXXFLAGS}:" \
		-e "s:QMAKE_CFLAGS_RELEASE = .*:QMAKE_CFLAGS_RELEASE = ${CFLAGS}:" \
		-i 'settings.pro' || die "Initial setup failed"

	if ! use nls ; then
		sed -e "s:i18n::" \
			-i ${package}.pro || die "Disable i18n failed"
	fi

        if use debug ; then
		FEATURES="${FEATURES} nostrip"
                sed -e 's:#CONFIG += debug:CONFIG += debug:' \
                        -e 's:CONFIG += release:#CONFIG += release:' \
                        -i 'settings.pro' || die "enable debug failed"
	fi

	setup_pro

	find ${S} -name '*.pro' -exec sed -i \
		-e "s:\$\${PREFIX}/lib/:\$\${PREFIX}/$(get_libdir)/:g" \
		-e "s:\$\${PREFIX}/lib$:\$\${PREFIX}/$(get_libdir):g" \
		{} \;
}

myth_src_compile() {
	export QMAKESPEC="linux-g++"

	qmake -o "Makefile" "${PN}.pro"
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" "${@}" || die
}

myth_src_install() {
	einstall INSTALL_ROOT="${D}"
	for doc in AUTHORS COPYING FAQ UPGRADING ChangeLog README; do
		test -e "${doc}" && dodoc ${doc}
	done
}
