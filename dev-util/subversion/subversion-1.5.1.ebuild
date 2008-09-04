# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/subversion/subversion-1.5.1.ebuild,v 1.5 2008/09/04 20:45:31 ranger Exp $

EAPI="1"
WANT_AUTOMAKE="none"

inherit autotools bash-completion confutils depend.apache elisp-common eutils flag-o-matic java-pkg-opt-2 libtool multilib perl-module python

DESCRIPTION="Advanced version control system"
HOMEPAGE="http://subversion.tigris.org/"
SRC_URI="http://subversion.tigris.org/downloads/${P/_/-}.tar.bz2
	mirror://gentoo/${P}-ra_serf-improvements.patch.bz2"

LICENSE="Subversion"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="apache2 berkdb debug doc +dso emacs extras java nls perl python ruby sasl vim-syntax +webdav-neon webdav-serf"
RESTRICT="test"

CDEPEND=">=dev-libs/apr-1.2.8
	>=dev-libs/apr-util-1.2.8
	dev-libs/expat
	sys-libs/zlib
	berkdb? ( =sys-libs/db-4* )
	emacs? ( virtual/emacs )
	ruby? ( >=dev-lang/ruby-1.8.2 )
	sasl? ( dev-libs/cyrus-sasl )
	webdav-neon? ( >=net-misc/neon-0.28 )
	webdav-serf? ( net-libs/serf )"

RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.5 )
	nls? ( virtual/libintl )
	perl? ( dev-perl/URI )"

DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )
	nls? ( sys-devel/gettext )"

want_apache

S="${WORKDIR}"/${P/_/-}

# Allow for custom repository locations.
# This can't be in pkg_setup because the variable needs to be available to
# pkg_config.
: ${SVN_REPOS_LOC:=/var/svn}

pkg_setup() {
	confutils_use_depend_built_with_all berkdb dev-libs/apr-util berkdb
	java-pkg-opt-2_pkg_setup

	if ! use webdav-neon && ! use webdav-serf; then
		ewarn
		ewarn "WebDAV support is disabled. You need WebDAV to"
		ewarn "access repositories through the HTTP protocol."
		ewarn
		ewarn "WebDAV support needs one of the following USE flags enabled:"
		ewarn "  webdav-neon webdav-serf"
		ewarn
		ewarn "You can do this by enabling one of these flags in /etc/portage/package.use:"
		ewarn "    =${CATEGORY}/${PF} webdav-neon webdav-serf"
		ewarn
		ebeep
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/1.5.0/disable-unneeded-linking.patch
	epatch "${WORKDIR}"/${P}-ra_serf-improvements.patch

	sed -i -e '/NEON_\(ALLOWED_LIST\|RECOMMENDED_VER\)/s/0\.28\.2/& 0.28.3/g' configure.ac

	sed -i \
		-e "s/\(BUILD_RULES=.*\) bdb-test\(.*\)/\1\2/g" \
		-e "s/\(BUILD_RULES=.*\) test\(.*\)/\1\2/g" configure.ac

	sed -e 's:@bindir@/svn-contrib:@libdir@/subversion/bin:' \
		-e 's:@bindir@/svn-tools:@libdir@/subversion/bin:' \
		-i Makefile.in

	eautoconf
	elibtoolize
}

src_compile() {
	local myconf

	if use python || use perl || use ruby; then
		myconf="${myconf} --with-swig"
	else
		myconf="${myconf} --without-swig"
	fi

	if use debug; then
		append-cppflags -DSVN_DEBUG -DAP_DEBUG
	fi

	append-flags -fno-strict-aliasing

	econf ${myconf} \
		$(use_with apache2 apxs "${APXS}") \
		$(use_with berkdb berkeley-db) \
		$(use_enable dso runtime-module-search) \
		$(use_enable java javahl) \
		$(use_with java jdk "${JAVA_HOME}") \
		$(use_enable nls) \
		$(use_with sasl) \
		$(use_with webdav-neon neon /usr) \
		$(use_with webdav-serf serf /usr) \
		--with-apr=/usr/bin/apr-1-config \
		--with-apr-util=/usr/bin/apu-1-config \
		--disable-experimental-libtool \
		--without-jikes \
		--without-junit \
		--disable-mod-activation

	# Respect the user LDFLAGS when building Subversion SWIG bindings.
	export SWIG_LDFLAGS="${LDFLAGS}"

	emake local-all || die "Building of core Subversion failed"

	if use python; then
		emake swig-py || die "Building of Subversion Python bindings failed"
	fi

	if use perl; then
		emake -j1 swig-pl || die "Building of Subversion Perl bindings failed"
	fi

	if use ruby; then
		emake swig-rb || die "Building of Subversion Ruby bindings failed"
	fi

	if use java; then
		make JAVAC_FLAGS="$(java-pkg_javac-args) -encoding iso8859-1" javahl \
			|| die "Building of Subversion JavaHL library failed"
	fi

	if use emacs; then
		elisp-compile contrib/client-side/emacs/dsvn.el || die "Compilation of Emacs module failed"
		elisp-compile contrib/client-side/emacs/psvn.el || die "Compilation of Emacs module failed"
		elisp-compile doc/svn-doc.el || die "Compilation of Emacs module failed"
		elisp-compile doc/tools/svnbook.el || die "Compilation of Emacs module failed"
	fi

	if use extras; then
		emake contrib || die "Building of contrib failed"
		emake tools || die "Building of tools failed"
	fi

	if use doc; then
		doxygen doc/doxygen.conf || die "Building of Subversion HTML documentation failed"

		if use java; then
			emake doc-javahl || die "Building of Subversion JavaHL library HTML documentation failed"
		fi
	fi
}

src_install() {
	python_version
	PYTHON_DIR=/usr/$(get_libdir)/python${PYVER}

	emake -j1 DESTDIR="${D}" local-install || die "Installation of core of Subversion failed"

	if use python; then
		emake -j1 DESTDIR="${D}" DISTUTIL_PARAM="--prefix=${D}" LD_LIBRARY_PATH="-L${D}/usr/$(get_libdir)" install-swig-py \
			|| die "Installation of Subversion Python bindings failed"

		# Move Python bindings.
		dodir "${PYTHON_DIR}/site-packages"
		mv "${D}"/usr/$(get_libdir)/svn-python/svn "${D}${PYTHON_DIR}/site-packages"
		mv "${D}"/usr/$(get_libdir)/svn-python/libsvn "${D}${PYTHON_DIR}/site-packages"
		rm -Rf "${D}"/usr/$(get_libdir)/svn-python
	fi

	if use perl; then
		emake -j1 DESTDIR="${D}" INSTALLDIRS="vendor" install-swig-pl || die "Installation of Subversion Perl bindings failed"
		fixlocalpod
	fi

	if use ruby; then
		emake -j1 DESTDIR="${D}" install-swig-rb || die "Installation of Subversion Ruby bindings failed"
	fi

	if use java; then
		emake -j1 DESTDIR="${D}" install-javahl || die "Installation of Subversion JavaHL library failed"
		java-pkg_regso "${D}"/usr/$(get_libdir)/libsvnjavahl*.so
		java-pkg_dojar "${D}"/usr/$(get_libdir)/svn-javahl/svn-javahl.jar
		rm -Rf "${D}"/usr/$(get_libdir)/svn-javahl/*.jar
	fi

	# Install Apache module configuration.
	if use apache2; then
		dodir "${APACHE_MODULES_CONFDIR}"
		cat <<EOF >"${D}/${APACHE_MODULES_CONFDIR}"/47_mod_dav_svn.conf
<IfDefine SVN>
LoadModule dav_svn_module modules/mod_dav_svn.so
<IfDefine SVN_AUTHZ>
LoadModule authz_svn_module modules/mod_authz_svn.so
</IfDefine>

# Example configuration:
#<Location /svn/repos>
#	DAV svn
#	SVNPath ${SVN_REPOS_LOC}/repos
#	AuthType Basic
#	AuthName "Subversion repository"
#	AuthUserFile ${SVN_REPOS_LOC}/conf/svnusers
#	Require valid-user
#</Location>
</IfDefine>
EOF
	fi

	# Install Bash Completion, bug 43179.
	dobashcompletion tools/client-side/bash_completion subversion
	rm -f tools/client-side/bash_completion

	# Install hot backup script, bug 54304.
	newbin tools/backup/hot-backup.py svn-hot-backup
	rm -fr tools/backup

	# Install svn_load_dirs.pl.
	if use perl; then
		newbin contrib/client-side/svn_load_dirs/svn_load_dirs.pl svn-load-dirs
	fi
	rm -f contrib/client-side/svn_load_dirs/svn_load_dirs.pl

	# Install svnserve init-script and xinet.d snippet, bug 43245.
	newinitd "${FILESDIR}"/svnserve.initd svnserve
	if use apache2; then
		newconfd "${FILESDIR}"/svnserve.confd svnserve
	else
		newconfd "${FILESDIR}"/svnserve.confd2 svnserve
	fi
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/svnserve.xinetd svnserve

	# Install documentation.
	dodoc CHANGES COMMITTERS README
	dohtml www/hacking.html
	dodoc tools/xslt/svnindex.{css,xsl}
	rm -fr tools/xslt

	# Install Vim syntax files.
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins contrib/client-side/vim/svn.vim
	fi
	rm -f contrib/client-side/vim/svn.vim

	# Install Emacs Lisps.
	if use emacs; then
		elisp-install ${PN} contrib/client-side/emacs/dsvn.el*
		elisp-install ${PN} contrib/client-side/emacs/psvn.el*
		elisp-install ${PN} doc/svn-doc.el*
		elisp-install ${PN} doc/tools/svnbook.el*
		elisp-site-file-install "${FILESDIR}"/1.5.0/70svn-gentoo.el
	fi
	rm -fr contrib/client-side/emacs

	# Install extra files.
	if use extras; then
		doenvd "${FILESDIR}"/1.5.0/80subversion-extras

		emake DESTDIR="${D}" install-contrib || die "Installation of contrib failed"
		emake DESTDIR="${D}" install-tools || die "Installation of tools failed"

		find contrib tools '(' -name "*.bat" -o -name "*.in" -o -name ".libs" ')' -print0 | xargs -0 rm -fr
		rm -fr contrib/client-side/{svn-push,svnmucc}
		rm -fr tools/server-side/{svn-populate-node-origins-index,svnauthz-validate}*
		rm -fr tools/{buildbot,dev,diff,po}

		insinto /usr/share/${PN}
		doins -r contrib tools
	fi

	if use doc; then
		dohtml doc/doxygen/html/*

		insinto /usr/share/doc/${PF}
		doins -r notes
		ecompressdir /usr/share/doc/${PF}/notes

		if use java; then
			java-pkg_dojavadoc doc/javadoc
		fi
	fi
}

pkg_preinst() {
	# Compare versions of Berkeley DB, bug 122877.
	if use berkdb && [[ -f "${ROOT}usr/bin/svn" ]] ; then
		OLD_BDB_VERSION="$(scanelf -nq "${ROOT}usr/$(get_libdir)/libsvn_subr-1.so.0" | grep -Eo "libdb-[[:digit:]]+\.[[:digit:]]+" | sed -e "s/libdb-\(.*\)/\1/")"
		NEW_BDB_VERSION="$(scanelf -nq "${D}usr/$(get_libdir)/libsvn_subr-1.so.0" | grep -Eo "libdb-[[:digit:]]+\.[[:digit:]]+" | sed -e "s/libdb-\(.*\)/\1/")"
		if [[ "${OLD_BDB_VERSION}" != "${NEW_BDB_VERSION}" ]] ; then
			CHANGED_BDB_VERSION=1
		fi
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use perl && perl-module_pkg_postinst

	elog "Subversion Server Notes"
	elog "-----------------------"
	elog
	elog "If you intend to run a server, a repository needs to be created using"
	elog "svnadmin (see man svnadmin) or the following command to create it in"
	elog "${SVN_REPOS_LOC}:"
	elog
	elog "    emerge --config =${CATEGORY}/${PF}"
	elog
	elog "Subversion has multiple server types, take your pick:"
	elog
	elog " - svnserve daemon: "
	elog "   1. Edit /etc/conf.d/svnserve"
	elog "   2. Start daemon: /etc/init.d/svnserve start"
	elog "   3. Make persistent: rc-update add svnserve default"
	elog
	elog " - svnserve via xinetd:"
	elog "   1. Edit /etc/xinetd.d/svnserve (remove disable line)"
	elog "   2. Restart xinetd.d: /etc/init.d/xinetd restart"
	elog
	elog " - svn over ssh:"
	elog "   1. Fix the repository permissions:"
	elog "        groupadd svnusers"
	elog "        chown -R root:svnusers ${SVN_REPOS_LOC}/repos/"
	elog "        chmod -R g-w ${SVN_REPOS_LOC}/repos"
	elog "        chmod -R g+rw ${SVN_REPOS_LOC}/repos/db"
	elog "        chmod -R g+rw ${SVN_REPOS_LOC}/repos/locks"
	elog "   2. Create an svnserve wrapper in /usr/local/bin to set the umask you"
	elog "      want, for example:"
	elog "         #!/bin/bash"
	elog "         . /etc/conf.d/svnserve"
	elog "         umask 002"
	elog "         exec /usr/bin/svnserve \${SVNSERVE_OPTS} \"\$@\""
	elog

	if use apache2; then
		elog " - http-based server:"
		elog "   1. Edit /etc/conf.d/apache2 to include both \"-D DAV\" and \"-D SVN\""
		elog "   2. Create an htpasswd file:"
		elog "      htpasswd2 -m -c ${SVN_REPOS_LOC}/conf/svnusers USERNAME"
		elog
	fi

	elog "If you intend to use svn-hot-backup, you can specify the number of"
	elog "backups to keep per repository by specifying an environment variable."
	elog "If you want to keep e.g. 2 backups, do the following:"
	elog "echo '# hot-backup: Keep that many repository backups around' > /etc/env.d/80subversion"
	elog "echo 'SVN_HOTBACKUP_BACKUPS_NUMBER=2' >> /etc/env.d/80subversion"
	elog

	if [[ -n "${CHANGED_BDB_VERSION}" ]] ; then
		ewarn "You upgraded from an older version of Berkeley DB and may experience"
		ewarn "problems with your repository. Run the following commands as root to fix it:"
		ewarn "    db4_recover -h ${SVN_REPOS_LOC}/repos"
		ewarn "    chown -Rf apache:apache ${SVN_REPOS_LOC}/repos"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use perl && perl-module_pkg_postrm
}

pkg_config() {
	if [[ ! -x "${ROOT}usr/bin/svnadmin" ]] ; then
		die "You seem to only have built the Subversion client"
	fi

	einfo ">>> Initializing the database in ${ROOT}${SVN_REPOS_LOC} ..."
	if [[ -e "${ROOT}${SVN_REPOS_LOC}/repos" ]] ; then
		echo "A Subversion repository already exists and I will not overwrite it."
		echo "Delete ${ROOT}${SVN_REPOS_LOC}/repos first if you're sure you want to have a clean version."
	else
		mkdir -p "${ROOT}${SVN_REPOS_LOC}/conf"

		einfo ">>> Populating repository directory ..."
		# Create initial repository.
		"${ROOT}usr/bin/svnadmin" create "${ROOT}${SVN_REPOS_LOC}/repos"

		einfo ">>> Setting repository permissions ..."
		SVNSERVE_USER="$(. "${ROOT}etc/conf.d/svnserve" ; echo "${SVNSERVE_USER}")"
		SVNSERVE_GROUP="$(. "${ROOT}etc/conf.d/svnserve" ; echo "${SVNSERVE_GROUP}")"
		if use apache2 ; then
			[[ -z "${SVNSERVE_USER}" ]] && SVNSERVE_USER="apache"
			[[ -z "${SVNSERVE_GROUP}" ]] && SVNSERVE_GROUP="apache"
		else
			[[ -z "${SVNSERVE_USER}" ]] && SVNSERVE_USER="svn"
			[[ -z "${SVNSERVE_GROUP}" ]] && SVNSERVE_GROUP="svnusers"
			enewgroup "${SVNSERVE_GROUP}"
			enewuser "${SVNSERVE_USER}" -1 -1 ${SVN_REPOS_LOC} "${SVNSERVE_GROUP}"
		fi
		chown -Rf "${SVNSERVE_USER}:${SVNSERVE_GROUP}" "${ROOT}${SVN_REPOS_LOC}/repos"
		chmod -Rf 755 "${ROOT}${SVN_REPOS_LOC}/repos"
	fi
}
