# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-community/mysql-community-5.0.27-r1.ebuild,v 1.4 2008/11/14 09:43:04 robbat2 Exp $

MY_EXTRAS_VER="20070105"
SERVER_URI="mirror://mysql/Downloads/MySQL-${PV%.*}/mysql-${PV//_/-}.tar.gz"

inherit mysql
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

src_test() {
	make check || die "make check failed"
	if ! use "minimal" ; then
		cd "${S}"
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus
		local t
		addpredict /this-dir-does-not-exist/t9.MYI

		# mysqladmin start before dir creation
		mkdir -p "${S}"/mysql-test/var{,/log}

		if ! hasq "userpriv" ${FEATURES} ; then
			mysql_disable_test	"im_daemon_life_cycle"	"fails as root"
			mysql_disable_test	"im_life_cycle"			"fails as root"
			mysql_disable_test	"im_options_set"		"fails as root"
			mysql_disable_test	"im_options_unset"		"fails as root"
			mysql_disable_test	"im_utils"				"fails as root"
		fi

		for t in \
		loaddata_autocom_ndb \
		ndb_{alter_table{,2},autodiscover{,2,3},basic,bitfield,blob} \
		ndb_{cache{,2},cache_multi{,2},charset,condition_pushdown,config} \
		ndb_{database,gis,index,index_ordered,index_unique,insert,limit} \
		ndb_{loaddatalocal,lock,minmax,multi,read_multi_range,rename,replace} \
		ndb_{restore,subquery,transaction,trigger,truncate,types,update} \
		ps_7ndb rpl_ndb_innodb_trans strict_autoinc_5ndb
		do
			mysql_disable_test	"${t}"	"fails with sandbox enabled"
		done

		use "extraengine" && mysql_disable_test "federated" "fails with extraengine USE"

		make test-force-pl
		retstatus=$?

		# Just to be sure ;)
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		[[ $retstatus -eq 0 ]] || die "make test failed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}
