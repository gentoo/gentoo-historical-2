# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/apache/apache-2.0.54.ebuild,v 1.4 2005/04/25 01:54:54 beu Exp $

inherit eutils gnuconfig

# latest gentoo apache files
GENTOO_PATCHNAME="gentoo-apache-${PVR}"
GENTOO_PATCHSTAMP="20050416"
GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"

DESCRIPTION="The Apache Web Server, Version 2.0.x"
HOMEPAGE="http://httpd.apache.org/"
#SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2
SRC_URI="http://httpd.apache.org/dev/dist/httpd-${PV}.tar.bz2
	mirror://gentoo/${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="apache2 debug doc ldap mpm-leader mpm-peruser mpm-prefork mpm-threadpool mpm-worker no-suexec ssl static-modules threads"

RDEPEND="dev-lang/perl
	~dev-libs/apr-0.9.6
	~dev-libs/apr-util-0.9.6
	dev-libs/expat
	net-www/gentoo-webroot-default
	app-misc/mime-types
	sys-libs/zlib
	ssl? ( dev-libs/openssl )
	selinux? ( sec-policy/selinux-apache )
	!mips? ( ldap? ( =net-nds/openldap-2* ) )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.59-r4"

S="${WORKDIR}/httpd-${PV}"

pkg_setup() {
	if use mpm-peruser; then
		ewarn " -BIG- -FAT- -WARNING-"
		ewarn ""
		ewarn "The peruser (USE=mpm-peruser) MPM is considered highly experimental"
		ewarn "and are not (yet) supported, nor are they recommended for production"
		ewarn "use.  You have been warned!"
		ewarn
		ewarn "Continuing in 5 seconds.."
		sleep 5
	fi
}

src_unpack() {
	unpack ${A} || die
	cd ${S} || die

	EPATCH_SUFFIX="patch"
	epatch ${GENTOO_PATCHDIR}/patches/[0-2]* || die "internal ebuild error"

	# avoid utf-8 charset problems
	export LC_CTYPE=C

	# setup the filesystem layout config
	cat ${GENTOO_PATCHDIR}/patches/config.layout >> config.layout
	sed -i -e 's:version:${PF}:g' config.layout

	# peruser need to build conf
	WANT_AUTOCONF=2.5 ./buildconf || die "buildconf failed"
}

src_compile() {
	setup_apache_vars

	# Detect mips and uclibc systems properly
	gnuconfig_update

	local modtype
	if useq static-modules; then
		modtype="static"
	else
		modtype="shared"
	fi

	select_modules_config || die "determining modules"

	local myconf
	useq ldap && myconf="${myconf} --enable-auth-ldap=${modtype} --enable-ldap=${modtype}"
	useq ssl && myconf="${myconf} --with-ssl=/usr  --enable-ssl=${modtype}"

	# Fix for bug #24215 - robbat2@gentoo.org, 30 Oct 2003
	# We pre-load the cache with the correct answer!  This avoids
	# it violating the sandbox.  This may have to be changed for
	# non-Linux systems or if sem_open changes on Linux.  This
	# hack is built around documentation in /usr/include/semaphore.h
	# and the glibc (pthread) source
	echo 'ac_cv_func_sem_open=${ac_cv_func_sem_open=no}' >> ${S}/config.cache

	if useq no-suexec; then
		myconf="${myconf} --disable-suexec"
	else
		myconf="${myconf}
				--with-suexec-safepath="/usr/local/bin:/usr/bin:/bin" \
				--with-suexec-logfile=/var/log/apache2/suexec_log \
				--with-suexec-bin=/usr/sbin/suexec2 \
				--with-suexec-userdir=${USERDIR} \
				--with-suexec-caller=apache \
				--with-suexec-docroot=/var/www \
				--with-suexec-uidmin=1000 \
				--with-suexec-gidmin=100 \
				--with-suexec-umask=077 \
				--enable-suexec=shared"
	fi

	# common confopts
	myconf="${myconf} \
			--with-apr=/usr \
			--with-apr-util=/usr \
			--cache-file=${S}/config.cache \
			--with-perl=/usr/bin/perl \
			--with-expat=/usr \
			--with-z=/usr \
			--with-port=80 \
			--enable-layout=Gentoo \
			--with-program-name=apache2 \
			--with-devrandom=/dev/urandom \
			--host=${CHOST} ${MY_BUILTINS}"

	# debugging support
	if useq debug ; then
		myconf="${myconf} --enable-maintainer-mode"
	fi

	select_mpms

	# now we build each mpm
	for mpm in ${mpms}; do
		# clean up
		cd server; make clean; cd ..

		./configure --with-mpm=${mpm} ${myconf} || die "bad ./configure please submit bug report to bugs.gentoo.org. Include your config.layout and config.log"

		# we don't want to try and recompile the ssl_expr_parse.c file, because
		# the lex source is broken
		touch modules/ssl/ssl_expr_scan.c

		# as decided on IRC-AGENDA-10.2004, we use httpd.conf as standard config file name
		sed -i -e 's:apache2\.conf:httpd.conf:' include/ap_config_auto.h

		emake || die "problem compiling apache2"

		mv apache2 apache2.${mpm}
	done

	# build ssl version of apache bench (ab-ssl)
	if useq ssl; then
		cd support
		rm -f ab .libs/ab ab.lo ab.o
		make ab CFLAGS="${CFLAGS} -DUSE_SSL -lcrypto -lssl -I/usr/include/openssl -L/usr/lib" || die
		mv ab ab-ssl
		rm -f ab.lo ab.o
		make ab || die
	fi
}

src_install () {
	# setup apache user and group
	enewgroup apache 81
	enewuser apache 81 /bin/false /var/www apache

	# general install
	make DESTDIR=${D} install || die
	dodoc ABOUT_APACHE CHANGES INSTALL LAYOUT LICENSE README* ${GENTOO_PATCHDIR}/docs/robots.txt

	# protect the suexec binary
	if ! useq no-suexec; then
		fowners root:apache /usr/sbin/suexec
		fperms 4710 /usr/sbin/suexec
	fi

	# apxs needs this to pickup the right lib for install
	dosym /usr/lib /usr/lib/apache2/lib
	dosym /var/log/apache2 /usr/lib/apache2/logs
	dosym /etc/apache2 /usr/lib/apache2/conf

	# Credits to advx.org people for these scripts. Heck, thanks for
	# the nice layout and everything else ;-)
	exeinto /usr/sbin
	for i in apache2logserverstatus apache2splitlogfile; do
		doexe ${GENTOO_PATCHDIR}/scripts/${i}
	done
	# gentestcrt.sh only if USE=ssl
	useq ssl && doexe ${GENTOO_PATCHDIR}/scripts/gentestcrt.sh

	# some more scripts
	for i in split-logfile list_hooks.pl logresolve.pl log_server_status; do
		doexe ${S}/support/${i}
	done

	# the ssl version of apache bench
	useq ssl && doexe support/ab-ssl

	# install mpm bins
	for mpm in ${mpms}; do
		doexe ${S}/apache2.${mpm}
	done

	# symlink the default mpm
	for i in prefork worker peruser threadpool leader; do
	if [ -x ${D}/usr/sbin/apache2.${i} ]; then
			dosym /usr/sbin/apache2.${i} /usr/sbin/apache2
			break
		fi
	done

	# modules.d config file snippets
	insinto /etc/apache2/modules.d
	doins ${GENTOO_PATCHDIR}/conf/modules.d/45_mod_dav.conf
	useq ldap && doins ${GENTOO_PATCHDIR}/conf/modules.d/46_mod_ldap.conf
	if useq ssl; then
		doins ${GENTOO_PATCHDIR}/conf/modules.d/40_mod_ssl.conf
		doins ${GENTOO_PATCHDIR}/conf/modules.d/41_mod_ssl.default-vhost.conf
	fi

	# drop in a convenient link to the manual
	if useq doc; then
		insinto /etc/apache2/modules.d
		doins ${GENTOO_PATCHDIR}/conf/modules.d/00_apache_manual.conf
		sed -i -e "s:2.0.49:${PVR}:" ${D}/etc/apache2/modules.d/00_apache_manual.conf
	else
		rm -rf ${D}/usr/share/doc/${PF}/manual
	fi

	# SLOT=2
	cd ${D}
	for i in htdigest htpasswd logresolve apxs ab rotatelogs dbmmanage checkgid split-logfile; do
		mv -v usr/sbin/${i} usr/sbin/${i}2
	done
	mv -v usr/sbin/apachectl usr/sbin/apache2ctl
	mv -v usr/sbin/list_hooks.pl usr/sbin/list_hooks2.pl
	mv -v usr/sbin/logresolve.pl usr/sbin/logresolve2.pl
	useq ssl && mv -v usr/sbin/ab-ssl usr/sbin/ab2-ssl
	useq no-suexec || mv -v usr/sbin/suexec usr/sbin/suexec2

	# do the man pages
	for i in htdigest.1 htpasswd.1 dbmmanage.1; do
		mv -v usr/share/man/man1/${i} usr/share/man/man1/${i/./2.}
	done
	for i in ab.8 apxs.8 logresolve.8 rotatelogs.8; do
		mv -v usr/share/man/man8/${i} usr/share/man/man8/${i/./2.}
	done
	useq no-suexec || mv -v usr/share/man/man8/suexec.8 usr/share/man/man8/suexec2.8
	mv -v usr/share/man/man8/apachectl.8 usr/share/man/man8/apache2ctl.8
	mv -v usr/share/man/man8/httpd.8 usr/share/man/man8/apache2.8

	# tidy up
	mv usr/sbin/envvars* usr/lib/apache2/build
	dodoc etc/apache2/*-std.conf
	rm -f etc/apache2/*.conf
	rm -rf var/run var/log

	# we DEPEND on net-www/gentoo-webroot-default for sharing this by now
	rm -rf var/www/localhost

	# config files
	insinto /etc/conf.d
	newins ${GENTOO_PATCHDIR}/init/apache2.confd apache2

	exeinto /etc/init.d
	newexe ${GENTOO_PATCHDIR}/init/apache2.initd apache2

	insinto /etc/logrotate.d
	newins ${GENTOO_PATCHDIR}/scripts/apache2-logrotate apache2

	insinto /etc/apache2
	doins ${GENTOO_PATCHDIR}/conf/apache2-builtin-mods
	doins ${GENTOO_PATCHDIR}/conf/httpd.conf

	keepdir /etc/apache2/vhosts.d
	keepdir /etc/apache2/modules.d

	# empty dirs
	for i in /var/lib/dav /var/log/apache2 /var/cache/apache2; do
		keepdir ${i}
		fowners apache:apache ${i}
		fperms 755 ${i}
	done

	# We'll be needing /etc/apache2/ssl if USE=ssl
	useq ssl && keepdir /etc/apache2/ssl

}

pkg_postinst() {

	# Automatically generate test ceritificates if ssl USE flag is beeing set
	if useq ssl; then
		cd ${ROOT}/etc/apache2/ssl
		einfo
		einfo "Generating self-signed test certificate in /etc/apache2/ssl..."
		yes "" 2>/dev/null | \
			${ROOT}/usr/sbin/gentestcrt.sh >/dev/null 2>&1 || \
			die "gentestcrt.sh failed"
		einfo
	fi

	# Check for dual/upgrade install
	if has_version '=net-www/apache-1*' || ! use apache2 ; then
		ewarn
		ewarn "Please add the 'apache2' flag to your USE variable and (re)install"
		ewarn "any additional DSO modules you may wish to use with Apache-2.x."
		ewarn "Addon modules are configured in /etc/apache2/modules.d/"
		ewarn
	fi

	# Check to see if this is an upgrade
	if [ -d /home/httpd ]; then
		einfo
		einfo "Please remember to update your config files in /etc/apache2"
		einfo "as --datadir has been changed to ${DATADIR}, and ServerRoot"
		einfo "has changed to /usr/lib/apache2!"
		einfo
	fi

	# Check for obsolete symlinks
	local list=""
	for i in lib logs modules extramodules; do
		local d="/etc/apache2/${i}"
		[ -s "${d}" ] && list="${list} ${d}"
	done
	[ -n "${list}" ] && einfo "You should delete these old symlinks: ${list}"

	if has_version '<net-www/apache-2.0.52-r3' && has_version '>=net-www/apache-2.0.0' ; then
		einfo "Configuration locations have changed, you will need to migrate"
		einfo "your configuration from /etc/apache2/conf/apache2.conf and"
		einfo "/etc/apache2/conf/commonapache2.conf to /etc/apache2/httpd.conf."
		einfo
		einfo "Apache now checks for the old configuration and refuses to start"
		einfo "if it exists. You must remove the old configuration first"
		einfo
		einfo "You should also at this time rebuild all your modules"
		einfo
		einfo "For more information, see"
		einfo "    http://dev.gentoo.org/~vericgar/doc/apache-package-refresh.html"
		einfo
	fi
}

setup_apache_vars() {
	# actually we do not provide a very dynamic way of those vars
	# however, you may predefine them in shell before emerging
	# to override the official default locations

	# standard location for Gentoo Linux
	DATADIR="${DATADIR:-/var/www/localhost}"
	USERDIR="${USERDIR:-public_html}"

	einfo "DATADIR is set to: ${DATADIR}"
	einfo "USERDIR is set to: ${USERDIR}"
}

select_mpms() {
	useq mpm-prefork && mpms="${mpms} prefork"
	useq mpm-worker && mpms="${mpms} worker"
	useq mpm-peruser && mpms="${mpms} peruser"
	useq mpm-threadpool && mpms="${mpms} threadpool"
	useq mpm-leader && mpms="${mpms} leader"

	if [ "x${mpms}" = "x" ]; then
		if useq threads; then
			einfo "Threads specified without a mpm-specification, using mpm-worker."
			mpms="worker"
		else
			einfo "No MPM style was specified, defaulting to mpm-prefork."
			mpms="prefork"
		fi
	fi
}

parse_modules_config() {
	local name=""
	local disable=""
	[ -f ${1} ] || return 1

	for i in `cat $1 | sed "s/^#.*//"`; do
		if [ $i == "-" ]; then
			disable="true"
		elif [ -z "$name" ] && [ ! -z "`echo $i | grep "mod_"`" ]; then
			name=`echo $i | sed "s/mod_//"`
		elif [ "$disable" ] && ( [ $i == "static" ] || [ $i == "shared" ] ); then
			MY_BUILTINS="${MY_BUILTINS} --disable-$name"
			name="" ; disable=""
		elif [ $i == "static" ] || useq static-modules; then
			MY_BUILTINS="${MY_BUILTINS} --enable-$name=yes"
			name="" ; disable=""
		elif [ $i == "shared" ]; then
			MY_BUILTINS="${MY_BUILTINS} --enable-$name=shared"
			name="" ; disable=""
		fi
	done

	einfo "${1} options:\n${MY_BUILTINS}"
}

select_modules_config() {
	parse_modules_config /etc/apache2/apache2-builtin-mods || \
	parse_modules_config ${GENTOO_PATCHDIR}/conf/apache2-builtin-mods || \
	return 1
}

# vim:ts=4
