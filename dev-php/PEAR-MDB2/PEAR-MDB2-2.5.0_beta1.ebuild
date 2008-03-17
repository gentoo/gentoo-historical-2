# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2/PEAR-MDB2-2.5.0_beta1.ebuild,v 1.1 2008/03/17 12:51:13 jokey Exp $

inherit php-pear-r1

DESCRIPTION="Database Abstraction Layer"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="firebird mssql mysql mysqli oci8 oci8-instant-client postgres sqlite"

PDEPEND="firebird? ( >=dev-php/PEAR-MDB2_Driver_ibase-1.5.0_beta1 )
		mssql? ( >=dev-php/PEAR-MDB2_Driver_mssql-1.3.0_beta1 )
		mysql? ( >=dev-php/PEAR-MDB2_Driver_mysql-1.5.0_beta1 )
		mysqli? ( >=dev-php/PEAR-MDB2_Driver_mysqli-1.5.0_beta1 )
		oci8? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_beta1 )
		oci8-instant-client? ( >=dev-php/PEAR-MDB2_Driver_oci8-1.5.0_beta1 )
		postgres? ( >=dev-php/PEAR-MDB2_Driver_pgsql-1.5.0_beta1 )
		sqlite? ( >=dev-php/PEAR-MDB2_Driver_sqlite-1.5.0_beta1 )"
