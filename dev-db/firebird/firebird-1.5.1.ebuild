# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/firebird/firebird-1.5.1.ebuild,v 1.3 2004/09/08 15:12:46 gustavoz Exp $

inherit flag-o-matic eutils

extra_ver="4481"
DESCRIPTION="A relational database offering many ANSI SQL-92 features"
HOMEPAGE="http://firebird.sourceforge.net/"
SRC_URI="mirror://sourceforge/firebird/${P}.${extra_ver}.tar.bz2"

LICENSE="Interbase-1.0"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE="inetd"
RESTRICT="nouserpriv"

DEPEND="virtual/libc
	inetd? ( virtual/inetd )"

S=${WORKDIR}/${P}.${extra_ver}

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /opt/firebird firebird
}

src_compile() {
	# fix bug #33584
	#strip-flags -funroll-loops
	# but Meir intended "filter-flags -funroll-loops"; awaiting bug reports...

	filter-flags -fprefetch-loop-arrays
	filter-mfpmath sse

	local myconf="--prefix=/opt/firebird --with-editline"
	use inetd || myconf="${myconf} --enable-superserver"

	NOCONFIGURE=1
	./autogen.sh ${myconf} || die "couldn't run autogen.sh"
	find . -exec sed -i -e "s/-lcurses/-lncurses/g" {} \;
	econf ${myconf} || die "./configure failed"
	emake -j 1 || die "error during make"
}

src_install() {
	cd ${S}/gen
	make -f Makefile.install tarfile || die "Can't create buildroot tar file"
	cd ${D}
	tar zxpf ${S}/gen/Firebird?S-*/buildroot.tar.gz

	dodoc ${D}/opt/firebird/{README,WhatsNew,doc/*}
	docinto examples
	dodoc ${D}/opt/firebird/examples/*
	docinto sql.extensions
	dodoc ${D}/opt/firebird/doc/sql.extensions/*

	rm -r ${D}/opt/firebird/{README,WhatsNew,doc,misc}
	rm -r ${D}/opt/firebird/examples

	if use inetd ; then
		insinto /etc/xinetd.d ; newins ${FILESDIR}/${PN}-1.5.0.xinetd firebird
	else
		exeinto /etc/init.d ; newexe ${FILESDIR}/${PN}.init.d firebird
		insinto /etc/conf.d ; newins ${FILESDIR}/firebird.conf.d firebird
		fperms 640 /etc/conf.d/firebird
	fi
	insinto /etc/env.d ; newins ${FILESDIR}/70${P} 70firebird

	# Following is adapted from postinstall.sh

	# make sure everything is owned by firebird
	chown -R firebird:firebird ${D}/opt/firebird

	# make sure permissions are set
	chmod -R o= ${D}/opt/firebird

	# fix directories
	find ${D}/opt/firebird -print -type d | xargs chmod o=rx

	# set permissions for /bin
	cd ${D}/opt/firebird/bin
	chmod ug=rx,o= *
	chmod a=rx isql
	chmod a=rx qli

	use inetd && chmod ug=rxs,o= ${D}/opt/firebird/bin/{fb_lock_mgr,gds_drop,fb_inet_server}
	chmod u=rw,go=r ${D}/opt/firebird/{aliases.conf,firebird.conf}
	chmod ug=rw,o= ${D}/opt/firebird/{security.fdb,help/help.fdb}

	for i in include lib UDF intl; do chmod a=r ${D}/opt/firebird/${i}/*; done
	chmod ug=rx,o= ${D}/opt/firebird/{intl/fbintl,UDF/fbudf.so,UDF/ib_udf.so}

	# create links for back compatibility
	dosym /opt/firebird/lib/libfbclient.so /usr/lib/libgds.so
	dosym /opt/firebird/lib/libfbclient.so /usr/lib/libgds.so.0

	# move and link config files to /etc/firebird so they'll be protected
	dodir /etc/firebird
	mv ${D}/opt/firebird/{security.fdb,aliases.conf,firebird.conf} ${D}/etc/firebird
	dosym /etc/firebird/security.fdb /opt/firebird/security.fdb
	dosym /etc/firebird/aliases.conf /opt/firebird/aliases.conf
	dosym /etc/firebird/firebird.conf /opt/firebird/firebird.conf
}

pkg_postinst() {
	einfo
	einfo "1. If haven't done so already, please run:"
	einfo
	einfo "   \"ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config\""
	einfo
	einfo "   to create lockfiles, set permissions and more"
	einfo
	einfo "2. Firebird now runs with it's own user. Please remember to"
	einfo "   set permissions to firebird:firebird on databases you "
	einfo "   already have (if any)."
	einfo

	if ! use inetd
	then
		einfo "3. You've built the stand alone deamon version,"
		einfo "   SuperServer. If you were using pre 1.5.0 ebuilds"
		einfo "   you're probably have one installed via xinetd. please"
		einfo "   remember to disable it (usually in /etc/xinetd.d/firebird),"
		einfo "   since the current one has it's own init script under"
		einfo "   /etc/init.d"
	fi
}

pkg_config() {
	cd /opt/firebird

	# Create Lock files
	for i in isc_init1 isc_lock1 isc_event1
	do
		FileName=$i.`hostname`
		touch $FileName
		chown firebird:firebird $FileName
		chmod ug=rw,o= $FileName
	done

	# Create log
	if [ ! -h firebird.log ]
	then
		if [ -f firebird.log ]
		then
			mv firebird.log /var/log
		else
			touch /var/log/firebird.log
			chown firebird:firebird /var/log/firebird.log
			chmod ug=rw,o= /var/log/firebird.log
		fi

		# symlink the log to /var/log
		ln -s /var/log/firebird.log firebird.log
	fi

	# add gds_db to /etc/services
	if [ -z "`grep gds_db  /etc/services`" ]
	then
		echo -e "#\n#Service added for gds_db (firebird)\n#" >> /etc/services
		echo "gds_db		3050/tcp" >> /etc/services
		einfo "added gds_db to /etc/services"
	fi

	# if found /etc/isc4.gdb from previous install, backup, and restore as
	# /etc/security.fdb
	if [ -f /etc/firebird/isc4.gdb ]
	then
		# if we have scurity.fdb already, back it 1st
		if [ -f /etc/firebird/security.fdb ]
		then
			cp /etc/firebird/security.fdb /etc/firebird/security.fdb.old
		fi
		gbak -B /etc/firebird/isc4.gdb /etc/firebird/isc4.gbk
		gbak -R /etc/firebird/isc4.gbk /etc/firebird/security.fdb
		mv /etc/firebird/isc4.gdb /etc/firebird/isc4.gdb.old
		rm /etc/firebird/isc4.gbk

		# make sure they are readable only to firebird
		chown firebird:firebird /etc/firebird/{isc4.*,security.*}
		chmod 660 /etc/firebird/{isc4.*,security.*}

		einfo
		einfo "Converted old isc4.gdb to security.fdb, isc4.gdb has been "
		einfo "renamed to isc4.gdb.old. if you had previous security.fdb, "
		einfo "it's backed to security.fdb.old (all under /etc/firebird)."
		einfo
	fi

	# we need to enable local access to the server
	if [ ! -f /etc/hosts.equiv ]
	then
		touch /etc/hosts.equiv
		chown root.root /etc/hosts.equiv
		chmod u=rw,go=r /etc/hosts.equiv
	fi

	if [ -z "`grep 'localhost$' /etc/hosts.equiv`" ]
	then
		echo "localhost" >> /etc/hosts.equiv
		einfo "Added localhost to /etc/hosts.equiv"
	fi

	HS_NAME=`hostname`
	if [ -z "`grep ${HS_NAME} /etc/hosts.equiv`" ]
	then
		echo "${HS_NAME}" >> /etc/hosts.equiv
		einfo "Added ${HS_NAME} to /etc/hosts.equiv"
	fi

	einfo "If you're using UDFs, please remember to move them"
	einfo "to /opt/firebird/UDF"
}
