# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-sql/cl-sql-1.8.7.ebuild,v 1.1 2004/01/27 21:44:41 mkennedy Exp $

inherit common-lisp

DEB_PV=1

DESCRIPTION="A multi-platform SQL interface for Common Lisp"
HOMEPAGE="http://clsql.med-info.com/
	http://packages.debian.org/unstable/devel/cl-sql.html
	http://www.cliki.net/CLSQL"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-sql/cl-sql_${PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/c/cl-sql/cl-sql_${PV}-${DEB_PV}.diff.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="postgres mysql"
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-md5
	dev-lisp/cl-uffi
	postgres? ( dev-db/postgresql )
	mysql? ( dev-db/mysql )"

S=${WORKDIR}/cl-sql-${PV}

modules='clsql-base clsql clsql-postgresql-socket clsql-uffi'

src_unpack() {
	unpack ${A}
	epatch cl-sql_${PV}-${DEB_PV}.diff
	# prevent shared-objects from being rebuilt -- we really need
	# portage help for reverse dependencies :(
	epatch ${FILESDIR}/${PV}-no-shared-object-asdf-gentoo.patch
}

src_compile() {
	make -C uffi
	use mysql && make -C db-mysql
	use postgres && make -C db-postgresql

	# db-postgresql-socket doesn't depend on libraries, so we build
	# support for it regardless of postgres USE flag
}

src_install() {
	local clsrc=/usr/share/common-lisp/source
	local clsys=/usr/share/common-lisp/systems

	dodir $clsys

	# cl-sql-base

	insinto $clsrc/clsql-base/base ; doins base/*.lisp
	insinto $clsrc/clsql-base ; doins clsql-base.asd
	dosym $clsrc/clsql-base/clsql-base.asd $clsys/clsql-base.asd

	# cl-sql-uffi

	exeinto /usr/lib/clsql/
	doexe uffi/uffi.so
	insinto $clsrc/clsql-uffi/uffi ; doins uffi/*.lisp uffi/uffi.c
	insinto $clsrc/clsql-uffi ; doins clsql-uffi.asd
	dosym $clsrc/clsql-uffi/clsql-uffi.asd $clsys/clsql-uffi.asd

	# cl-sql

	insinto $clsrc/clsql/sql ; doins sql/*.lisp
	insinto $clsrc/clsql ; doins clsql.asd
	dosym $clsrc/clsql/clsql.asd $clsys/clsql.asd

	# cl-sql-postgresql-socket

	insinto $clsrc/clsql-postgresql-socket/db-postgresql-socket ; doins db-postgresql-socket/*.lisp
	insinto $clsrc/clsql-postgresql-socket ; doins clsql-postgresql-socket.asd
	dosym $clsrc/clsql-postgresql-socket/clsql-postgresql-socket.asd \
		$clsys/clsql-postgresql-socket.asd

	# cl-sql-postgresql (UFFI interface)

	if use postgres; then
		insinto $clsrc/clsql-postgresql/db-postgresql ; doins db-postgresql/*.lisp
		insinto $clsrc/clsql-postgresql ; doins clsql-postgresql.asd
		dosym $clsrc/clsql-postgresql/clsql-postgresql.asd $clsys/clsql-postgresql.asd
	fi

	# cl-sql-mysql (UFFI interface)

	if use mysql; then
		insinto $clsrc/clsql-mysql/db-mysql; doins db-mysql/*.lisp db-mysql/mysql.c
		insinto $clsrc/clsql-mysql; doins clsql-mysql.asd
		dosym $clsrc/clsql-mysql/clsql-mysql.asd $clsys/clsql-mysql.asd
		exeinto /usr/lib/clsql
		doexe db-mysql/mysql.so
	fi

	dodoc COPYING* ChangeLog INSTALL NEWS README TODO
	tar xfz doc/html.tar.gz -C ${D}/usr/share/doc/${P}/
	do-debian-credits
}

pkg_postinst() {
	for i in $modules ; do
		/usr/sbin/register-common-lisp-source $i
	done
	use postgres && /usr/sbin/register-common-lisp-source clsql-postgresql
	use mysql && /usr/sbin/register-common-lisp-source clsql-mysql
}

pkg_prerm() {
	for i in $modules ; do
		/usr/sbin/unregister-common-lisp-source $i
	done
	use postgres && /usr/sbin/unregister-common-lisp-source clsql-postgresql
	use mysql && /usr/sbin/unregister-common-lisp-source clsql-mysql
}


pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/clsql* || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/clsql* || true
}
