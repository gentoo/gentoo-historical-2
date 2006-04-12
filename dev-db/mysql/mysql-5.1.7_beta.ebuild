# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-5.1.7_beta.ebuild,v 1.6 2006/04/12 04:12:06 eradicator Exp $

MY_EXTRAS_VER="20060316"
MYSQL_VERSION_ID=""

inherit mysql
KEYWORDS="-*"

src_test() {
	cd ${S}
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	make check || die "make check failed"
	if ! useq minimal; then
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus
		addpredict /this-dir-does-not-exist/t9.MYI

		cd mysql-test
		sed -i -e "s|MYSQL_TCP_PORT=3306|MYSQL_TCP_PORT=3307|" mysql-test-run
		./mysql-test-run
		retstatus=$?

		# to be sure ;)
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		[[ $retstatus -eq 0 ]] || die "make test failed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}

