# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/subversion/subversion-1.2.3.ebuild,v 1.1 2005/08/27 20:21:20 pauldv Exp $

inherit elisp-common libtool python eutils bash-completion flag-o-matic perl-module

DESCRIPTION="A compelling replacement for CVS"
HOMEPAGE="http://subversion.tigris.org/"
SRC_URI="http://subversion.tigris.org/tarballs/${P/_rc/-rc}.tar.bz2"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="apache2 berkdb python emacs perl java nls nowebdav zlib"
RESTRICT="test"

# Presently subversion doesn't build with swig-1.3.22, bug 65424
RDEPEND="apache2? ( >=net-www/apache-2.0.48 !>=net-www/apache-2.0.54-r10 )
	!apache2? ( !>=net-www/apache-2 )
	!dev-libs/apr
	python? ( =dev-lang/swig-1.3.21 >=dev-lang/python-2.0 )
	perl? ( =dev-lang/swig-1.3.21 >=dev-lang/perl-5.8 )
	!nowebdav? ( >=net-misc/neon-0.24.7 )
	berkdb? ( =sys-libs/db-4* )
	zlib? ( sys-libs/zlib )
	java? ( virtual/jdk )
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.59"
# Does not work because jikes is broken
#	jikes? ( dev-java/jikes )"

S=${WORKDIR}/${P/_rc/-rc}

# Allow for custion repository locations.
# This can't be in pkg_setup because the variable needs to be available to
# pkg_config.
: ${SVN_REPOS_LOC:=/var/svn}

pkg_setup() {
	if use berkdb && has_version '<dev-util/subversion-0.34.0' && [[ -z ${SVN_DUMPED} ]]; then
		echo
		ewarn "Presently you have $(best_version subversion)"
		ewarn "Subversion has changed the repository filesystem schema from 0.34.0."
		ewarn "So you MUST dump your repositories before upgrading."
		ewarn
		ewarn 'After doing so call emerge with SVN_DUMPED=1 emerge !*'
		ewarn
		ewarn "More details on dumping:"
		ewarn "http://svn.collab.net/repos/svn/trunk/notes/repos_upgrade_HOWTO"
		echo
		die "Ensure that you dump your repository first"
	fi

	if use apache2; then
		echo
		einfo "The apache2 subversion module will be built, and libapr from the"
		einfo "apache package will be used instead of the included."
		echo
	else
		echo
		einfo "Please note that subversion and apache2 cannot be installed"
		einfo "simultaneously without specifying the apache2 use flag. This is"
		einfo "because subversion installs its own libapr and libapr-util in that"
		einfo "case. Specifying the apache2 useflag will also enable the building of"
		einfo "the apache2 module."
		echo
	fi
}

src_unpack() {
	unpack ${P/_rc/-rc}.tar.bz2
	cd ${S}

	epatch ${FILESDIR}/subversion-db4.patch
	epatch ${FILESDIR}/subversion-1.1.1-perl-vendor.patch

	export WANT_AUTOCONF=2.5
	elibtoolize
	autoconf
	(cd apr; autoconf)
	(cd apr-util; autoconf)
	sed -i -e 's,\(subversion/svnversion/svnversion.*\)\(>.*svn-revision.txt\),echo "exported" \2,' Makefile.in

	use emacs && cp ${FILESDIR}/vc-svn.el ${S}/contrib/client-side/vc-svn.el
}

src_compile() {
	local myconf

	use apache2 && myconf="${myconf} --with-apxs=/usr/sbin/apxs2 \
		--with-apr=/usr --with-apr-util=/usr"
	use apache2 || myconf="${myconf} --without-apxs"

	myconf="${myconf} $(use_enable java javahl)"
#	use java && myconf="${myconf} $(use_with jikes)"
	use java && myconf="${myconf} --without-jikes"

	if use python || use perl; then
		myconf="${myconf} --with-swig"
	else
		myconf="${myconf} --without-swig"
	fi

	if use nowebdav; then
		myconf="${myconf} --without-neon"
	else
		myconf="${myconf} --with-neon=/usr"
	fi

	if use apache2; then
		append-flags `/usr/bin/apr-config --cppflags`;
	fi

	econf ${myconf} \
		$(use_with berkdb berkeley-db) \
		$(use_with zlib) \
		$(use_with python) \
		$(use_enable nls) \
		--disable-experimental-libtool \
		--disable-mod-activation || die "econf failed"

	# Build subversion, but do it in a way that is safe for parallel builds.
	# Also apparently the included apr has a libtool that doesn't like -L flags.
	# So not specifying it at all when not building apache modules and only
	# specify it for internal parts otherwise.
	if use apache2; then
		( emake LT_LDFLAGS="-L${D}/usr/lib" external-all && emake LT_LDFLAGS="-L${D}/usr/lib" local-all ) || die "make of subversion failed"
	else
		( emake external-all && emake local-all ) || die "make of subversion failed"
	fi

	if use python; then
		# Building fails without the apache apr-util as includes are wrong.
		if use apache2; then
			emake swig-py || die "subversion python bindings failed"
		else
			emake SVN_APR_INCLUDES="-I${S}/apr/include -I${S}/apr-util/include" swig-py || die "subversion python bindings failed"
		fi
	fi

	if use perl; then
		# Work around a buggy Makefile.PL, bug 64634
		mkdir -p subversion/bindings/swig/perl/native/blib/arch/auto/SVN/{_Client,_Delta,_Fs,_Ra,_Repos,_Wc}
		make swig-pl || die "Perl library building failed"
	fi

	if use java; then
		# ensure that the destination dir exists, else some compilation fails
		mkdir -p ${S}/subversion/bindings/java/javahl/classes
		# Compile javahl
		make JAVACFLAGS="-source 1.3 -encoding iso8859-1" javahl || die "Compilation failed"
	fi

	if use emacs; then
		einfo "compiling emacs support"
		elisp-compile ${S}/contrib/client-side/psvn/psvn.el || die "emacs modules failed"
		elisp-compile ${S}/contrib/client-side/vc-svn.el || die "emacs modules failed"
	fi

	# svn-config isn't quite built correctly; it contains references to
	# @SVN_DB_LIBS@ and @SVN_DB_INCLUDES@.  It appears the best thing is to remove that.  #64634
	sed -i 's/@SVN_DB_[^@]*@//g' svn-config || die "sed failed"
}


src_install () {
	use apache2 && mkdir -p ${D}/etc/apache2/conf

	python_version
	PYTHON_DIR=/usr/lib/python${PYVER}

	make DESTDIR=${D} install || die "Installation of subversion failed"
	if [[ -e ${D}/usr/lib/apache2 ]]; then
		if has_version '>=net-www/apache-2.0.48-r2'; then
			mv ${D}/usr/lib/apache2/modules ${D}/usr/lib/apache2-extramodules
			rmdir ${D}/usr/lib/apache2
		else
			mv ${D}/usr/lib/apache2 ${D}/usr/lib/apache2-extramodules
		fi
	fi

	if has_version '>=net-www/apache-2.0.48-r2'; then
		chown -R root:root ${D}/usr/include/apr-0/
	fi


	dobin svn-config
	if use python; then
		make install-swig-py DESTDIR=${D} DISTUTIL_PARAM=--prefix=${D}  LD_LIBRARY_PATH="-L${D}/usr/lib" || die "Installation of subversion python bindings failed"

		# move python bindings
		mkdir -p ${D}${PYTHON_DIR}/site-packages
		mv ${D}/usr/lib/svn-python/svn ${D}${PYTHON_DIR}/site-packages
		mv ${D}/usr/lib/svn-python/libsvn ${D}${PYTHON_DIR}/site-packages
		rmdir ${D}/usr/lib/svn-python
	fi
	if use perl; then
		make DESTDIR=${D} install-swig-pl || die "Perl library building failed"
		fixlocalpod
	fi
	if use java; then
		make DESTDIR="${D}" install-javahl || die "installation failed"
	fi

	# Install apache module config
	if useq apache2; then
		mkdir -p ${D}/etc/apache2/conf/modules.d
		cat <<EOF >${D}/etc/apache2/conf/modules.d/47_mod_dav_svn.conf
<IfDefine SVN>
	<IfModule !mod_dav_svn.c>
		LoadModule dav_svn_module	extramodules/mod_dav_svn.so
	</IfModule>
	<Location /svn/repos>
		DAV svn
		SVNPath ${SVN_REPOS_LOC}/repos
		AuthType Basic
		AuthName "Subversion repository"
		AuthUserFile ${SVN_REPOS_LOC}/conf/svnusers
		Require valid-user
	</Location>
	<IfDefine SVN_AUTHZ>
		<IfModule !mod_authz_svn.c>
			LoadModule authz_svn_module	extramodules/mod_authz_svn.so
		</IfModule>
	</IfDefine>
</IfDefine>
EOF
	fi

	# Bug 43179 - Install bash-completion if user wishes
	dobashcompletion tools/client-side/bash_completion subversion

	# Install hot backup script, bug 54304
	newbin tools/backup/hot-backup.py svn-hot-backup

	# The svn_load_dirs script is installed by Debian and looks like a good
	# candidate for us to install as well
	newbin contrib/client-side/svn_load_dirs.pl svn-load-dirs

	# Install svnserve init-script and xinet.d snippet, bug 43245
	exeinto /etc/init.d ; newexe ${FILESDIR}/svnserve.initd svnserve
	insinto /etc/conf.d ; newins ${FILESDIR}/svnserve.confd svnserve
	insinto /etc/xinetd.d ; newins ${FILESDIR}/svnserve.xinetd svnserve

	# Install documentation

	dodoc BUGS COMMITTERS COPYING HACKING INSTALL README
	dodoc CHANGES
	dodoc tools/xslt/svnindex.css tools/xslt/svnindex.xsl
	find contrib tools -name \*.in -print0 | xargs -0 rm -f
	cp -r --parents tools/{client-side,examples,hook-scripts} ${D}/usr/share/doc/${PF}/
	cp -r --parents contrib/hook-scripts ${D}/usr/share/doc/${PF}/

	docinto notes
	for f in notes/*
	do
		[[ -f ${f} ]] && dodoc ${f}
	done

	# Install the book in it's own dir
	docinto book
	cd ${S}
	echo "installing html book"
	dohtml -r doc/book/svn-book.html doc/book/styles.css doc/book/images || die "Installing book failed"

	# Install emacs lisps
	if use emacs; then
		insinto /usr/share/emacs/site-lisp/subversion
		doins contrib/client-side/psvn/psvn.el*
		doins contrib/client-side/vc-svn.el*

		elisp-site-file-install ${FILESDIR}/70svn-gentoo.el
	fi
}

src_test() {
	ewarn "Testing does not work for subversion"
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use perl && perl-module_pkg_postinst

	einfo "Subversion Server Notes"
	einfo "-----------------------"
	einfo

	einfo "If you intend to run a server, a repository needs to be created using"
	einfo "svnadmin (see man svnadmin) or the following command to create it in"
	einfo "/var/svn:"
	einfo
	einfo "    ebuild /path/to/ebuild/${PF}.ebuild config"
	einfo
	einfo "If you upgraded from an older version of berkely db and experience"
	einfo "problems with your repository then run the following commands as root:"
	einfo "    db4_recover -h ${SVN_REPOS_LOC}/repos"
	einfo "    chown -Rf apache:apache ${SVN_REPOS_LOC}/repos"
	einfo
	einfo "Subversion has multiple server types, take your pick:"
	einfo
	einfo " - svnserve daemon: "
	einfo "   1. edit /etc/conf.d/svnserve"
	einfo "   2. start daemon: /etc/init.d/svnserve start"
	einfo "   3. make persistent: rc-update add svnserve default"
	einfo
	einfo " - svnserve via xinetd:"
	einfo "   1. edit /etc/xinetd.d/svnserve (remove disable line)"
	einfo "   2. restart xinetd.d: /etc/init.d/xinetd restart"
	einfo
	einfo " - svn over ssh:"
	einfo "   1. Fix the repository permissions:"
	einfo "        groupadd svnusers"
	einfo "        chown -R root:svnusers /var/svn/repos/"
	einfo "        chmod -R g-w /var/svn/repos"
	einfo "        chmod -R g+rw /var/svn/repos/db"
	einfo "        chmod -R g+rw /var/svn/repos/locks"
	einfo "   2. create an svnserve wrapper in /usr/local/bin to set the umask you"
	einfo "      want, for example:"
	einfo "         #!/bin/bash"
	einfo "         umask 002"
	einfo "         exec /usr/bin/svnserve \"\$@\""
	einfo

	if use apache2 >/dev/null; then
		einfo " - http-based server:"
		einfo "   1. edit /etc/conf.d/apache2 to include both \"-D DAV\" and \"-D SVN\""
		einfo "   2. create an htpasswd file:"
		einfo "      htpasswd2 -m -c ${SVN_REPOS_LOC}/conf/svnusers USERNAME"
		einfo
	fi
}

pkg_postrm() {
	has_version virtual/emacs && elisp-site-regen
	use perl && perl-module_pkg_postrm
}

pkg_config() {
	if [[ ! -x /usr/bin/svnadmin ]]; then
		die "You seem to only have build the subversion client"
	fi

	einfo ">>> Initializing the database in ${SVN_REPOS_LOC}..."
	if [[ -e ${SVN_REPOS_LOC}/repos ]]; then
		echo "A subversion repository already exists and I will not overwrite it."
		echo "Delete ${SVN_REPOS_LOC}/repos first if you're sure you want to have a clean version."
	else
		mkdir -p ${SVN_REPOS_LOC}/conf
		einfo ">>> Populating repository directory ..."
		# create initial repository
		/usr/bin/svnadmin create ${SVN_REPOS_LOC}/repos

		einfo ">>> Setting repository permissions ..."
		chown -Rf apache:apache ${SVN_REPOS_LOC}/repos
		chmod -Rf 755 ${SVN_REPOS_LOC}/repos
	fi
}
