# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/apache/apache-1.3.33-r2.ebuild,v 1.3 2005/04/11 18:52:55 corsair Exp $

inherit eutils fixheadtails

# latest gentoo apache files
GENTOO_PATCHNAME="gentoo-apache-${PVR}"
GENTOO_PATCHSTAMP="20050320"
GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"

# The mod_ssl archive is only for providing the EAPI patch in here.
# You should install the net-www/mod_ssl package for the actual DSO.
mod_ssl_ver=2.8.22
lingerd_ver=0.94

DESCRIPTION="The Apache Web Server"
HOMEPAGE="http://httpd.apache.org"
SRC_URI="mirror://apache/httpd/apache_${PV}.tar.gz
		ssl? ( ftp://ftp.modssl.org/source/mod_ssl-${mod_ssl_ver}-${PV}.tar.gz )
		lingerd? ( http://images.iagora.com/media/software/lingerd/lingerd-${lingerd_ver}.tar.gz )
		mirror://gentoo/${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ~mips ppc64"
IUSE="doc ssl pam lingerd no-suexec static-modules apache2"

DEPEND="dev-lang/perl
		>=sys-libs/db-1.85-r1
		>=dev-libs/mm-1.1.3
		>=sys-libs/gdbm-1.8
		>=dev-libs/expat-1.95.2
		net-www/gentoo-webroot-default
		app-misc/mime-types
		selinux? ( sec-policy/selinux-apache )
		lingerd? ( =net-www/lingerd-${lingerd_ver} )"

# so leave it out until it's available
PDEPEND="ssl? ( =net-www/mod_ssl-${mod_ssl_ver}-r1 )"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	EPATCH_SUFFIX="patch"
	epatch ${GENTOO_PATCHDIR}/patches/[0-2]*

	# setup the filesystem layout config
	cat ${GENTOO_PATCHDIR}/patches/config.layout >> config.layout
	sed -i -e 's:version:${PF}:g' config.layout

	if useq pam; then
		epatch ${GENTOO_PATCHDIR}/patches/31_all_gentoo_suexec_pam.patch || die "pam patch failed"
	fi

	# fix obsolete 'head -1' and 'tail -1' calls
	ht_fix_file src/Configure src/helpers/getuid.sh src/helpers/buildinfo.sh src/helpers/fmn.sh

	# setup mod_ssl eapi
	if useq ssl; then
		local myssl
		myssl=${WORKDIR}/mod_ssl-${mod_ssl_ver}-${PV}
		cp ${myssl}/pkg.eapi/*.h src/include
		cp ${myssl}/pkg.eapi/*.c src/ap
		epatch ${myssl}/pkg.eapi/eapi.patch || die "failed to setup mod_ssl eapi"
	fi

	# set a reasonable MM_CORE_PATH location..
	sed -i -e 's:logs/mm:/var/cache/apache-mm/mm:' src/include/httpd.h

	if useq lingerd; then
		local mylingerd=${WORKDIR}/lingerd-${lingerd_ver}
		cp ${mylingerd}/apache-1.3/ap_lingerd.c ${mylingerd}/li_config.h src/main
		cd src
		if useq ssl; then
			epatch ${mylingerd}/apache-1.3/aplinger-ssl.diff
		else
			epatch ${mylingerd}/apache-1.3/aplinger.diff
		fi
		cd ..
	fi
}

src_compile() {
	local myconf

	setup_apache_vars

	select_modules_config || die "determining modules"

	if ! useq no-suexec; then
		myconf="${myconf}
				--enable-suexec
				--suexec-uidmin=1000 \
				--suexec-gidmin=100 \
				--suexec-caller=apache \
				--suexec-userdir=public_html \
				--suexec-docroot=/var/www \
				--suexec-safepath="/usr/local/bin:/usr/bin:/bin" \
				--suexec-logfile=/var/log/apache/suexec_log"
	fi

	if useq ssl; then
		myconf="${myconf} --enable-rule=EAPI"
	fi

	OPTIM="${MY_CFLAGS} -DHARD_SERVER_LIMIT=${HARD_SERVER_LIMIT:=512} \
		-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" \
	LIBS="-ldb -lgdbm -lgdbm_compat -lpthread" \
	EAPI_MM=SYSTEM \
	./configure \
		--with-layout=Gentoo \
		--target=apache \
		--server-uid=apache \
		--server-gid=apache \
		--with-perl=/usr/bin/perl \
		--enable-rule=SHARED_CHAIN \
		${MY_BUILTINS} ${myconf} || die "bad ./configure please submit bug report to bugs.gentoo.org. Include your config.layout and config.log"

	emake || die "problem compiling apache"

	# build ssl version of apache bench (ab-ssl)
	if useq ssl; then
		cd src/support
		rm -f ab ab.o
		make ab CFLAGS="${CFLAGS} -DUSE_SSL -lcrypto -lssl -I/usr/include/openssl -L/usr/lib" || die
		mv ab ab-ssl
		rm -f ab.o
		make ab || die
	fi
}

src_install() {
	# setup apache user and group
	enewgroup apache 81
	enewuser apache 81 /bin/false /var/www apache

	# general install
	make install-quiet root=${D} || die
	dodoc ABOUT_APACHE Announcement INSTALL LICENSE README* ${GENTOO_PATCHDIR}/docs/robots.txt

	# protect the suexec binary
	if ! useq no-suexec; then
		fowners root:apache /usr/sbin/suexec
		fperms 4710 /usr/sbin/suexec
	fi

	# apxs needs this to pickup the right lib for install
	dosym /usr/lib /usr/lib/apache/lib
	dosym /var/log/apache /usr/lib/apache/logs
	dosym /etc/apache /usr/lib/apache/conf

	# nice support scripts
	exeinto /usr/sbin
	for i in apachelogserverstatus apachesplitlogfile; do
		doexe ${GENTOO_PATCHDIR}/scripts/${i}
	done

	# some more scripts
	for i in split-logfile logresolve.pl log_server_status; do
		doexe ${S}/src/support/${i}
	done

	# the ssl version of apache bench
	if useq ssl; then
		doexe src/support/ab-ssl
	fi

	# drop in a convenient link to the manual
	if useq doc; then
		insinto /etc/apache/modules.d
		doins ${GENTOO_PATCHDIR}/conf/modules.d/00_apache_manual.conf
		sed -i -e "s:1.3.32:${PVR}:" ${D}/etc/apache/modules.d/00_apache_manual.conf
	else
		rm -rf ${D}/usr/share/doc/${PF}/manual
	fi

	# tidy up
	cd ${D}
	dodoc etc/apache/*.default
	rm -f etc/apache/*.default
	rm -f etc/apache/*.conf
	rm -f etc/apache/mime.types

	# we DEPEND on net-www/gentoo-webroot-default for sharing this by now
	rm -rf var/www/localhost

	# config files
	insinto /etc/conf.d
	newins ${GENTOO_PATCHDIR}/init/apache.confd apache

	exeinto /etc/init.d
	newexe ${GENTOO_PATCHDIR}/init/apache.initd apache

	insinto /etc/apache
	doins ${GENTOO_PATCHDIR}/conf/apache-builtin-mods
	doins ${GENTOO_PATCHDIR}/conf/httpd.conf

	keepdir /etc/apache/vhosts.d
	keepdir /etc/apache/modules.d

	# Added by Jason Wever <weeve@gentoo.org>
	# A little sedfu to fix bug #7172 for sparc64s
	if [ ${ARCH} = "sparc" ]; then
		sed -i -e '15a\AcceptMutex fcntl' ${D}/etc/apache/httpd.conf
	fi

	if useq lingerd; then
		sed -i 's:\(need net.*\):\1 lingerd:g' ${D}/etc/init.d/apache
	fi

	if useq pam; then
		insinto /etc/pam.d
		newins ${GENTOO_PATCHDIR}/patches/suexec.pam suexec
	fi

	# empty dirs
	for i in /var/log/apache /var/cache/apache /var/cache/apache-mm; do
		keepdir ${i}
		fowners apache:apache ${i}
		fperms 755 ${i}
	done
}

pkg_postinst() {
	einfo
	einfo "Please remember to update your config files in /etc/apache"
	einfo "as --datadir has been changed to ${DATADIR}, and ServerRoot"
	einfo "has changed to /usr/lib/apache!"
	einfo

	# Check for obsolete symlinks
	local list=""
	for i in lib logs modules extramodules; do
		local d="/etc/apache/${i}"
		[ -s "${d}" ] && list="${list} ${d}"
	done
	[ -n "${list}" ] && einfo "You should delete these old symlinks: ${list}"

	if has_version '<net-www/apache-1.3.33-r1' ; then
		einfo "Configuration locations have changed, you will need to migrate"
		einfo "your configuration from /etc/apache/conf/apache.conf and"
		einfo "/etc/apache/conf/commonapache.conf to /etc/apache/httpd.conf."
		einfo
		einfo "Apache now checks for the old configuration and refuses to start"
		einfo "if it exists. You must remove the old configuration first"
		einfo
		einfo "For more information, see"
		einfo "  http://dev.gentoo.org/~vericgar/doc/apache-package-refresh.html"
		einfo
	fi

	if use apache2 ; then
		ewarn "You have apache2 in USE. Any modules that you"
		ewarn "install may depend on apache-2.* instead of"
		ewarn "apache-1*. It's recommended that you remove"
		ewarn "apache2 from USE."
	fi


}

setup_apache_vars() {
	MY_CFLAGS="${CFLAGS}"
	unset CFLAGS
	unset CXXFLAGS

	# standard location for Gentoo Linux
	DATADIR="${DATADIR:-/var/www/localhost}"
	einfo "DATADIR is set to: ${DATADIR}"
}

parse_modules_config() {
	local name=""
	local disable=""
	[ -f ${1} ] || return 1

	for i in `cat $1 | sed "s/^#.*//"` ; do
		if [ $i == "-" ]; then
			disable="true"
		elif [ -z "$name" ] && [ ! -z "`echo $i | grep "mod_"`" ]; then
			name=`echo $i | sed "s/mod_//"`
		elif [ "$disable" ] && ( [ $i == "static" ] || [ $i == "shared" ] ); then
			MY_BUILTINS="${MY_BUILTINS} --disable-module=$name"
			name="" ; disable=""
		elif [ $i == "static" ] || useq static-modules; then
			MY_BUILTINS="${MY_BUILTINS} --enable-module=$name --disable-shared=$name"
			name="" ; disable=""
		elif [ $i == "shared" ]; then
			MY_BUILTINS="${MY_BUILTINS} --enable-module=$name --enable-shared=$name"
			name="" ; disable=""
		fi
	done

	einfo "${1} options:\n${MY_BUILTINS}"
}

select_modules_config() {
	parse_modules_config /etc/apache/apache-builtin-mods || \
	parse_modules_config ${GENTOO_PATCHDIR}/conf/apache-builtin-mods || \
	return 1
}

# vim:ts=4
